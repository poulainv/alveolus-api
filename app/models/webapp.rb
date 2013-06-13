   # == Schema Information
#
# Table name: webapps
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  caption            :string(255)
#  description        :text
#  validate           :boolean
#  url                :string(255)
#  image              :string(255)
#  average_rate       :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  nb_click_preview   :integer          default(0)
#  nb_click_detail    :integer          default(0)
#  nb_click_url       :integer          default(0)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  promoted           :boolean
#

class Webapp < ActiveRecord::Base

  attr_accessible :facebook_id,:twitter_id, :gplus_id,:average_rate,:vimeo_id,:user_id,:photo,:comments,:tags,:tag_list,:nb_click_preview, :promoted,  :nb_click_url,:nb_click_detail,:caption, :featured,:description, :title, :url, :validate, :category_id

  before_validation :uniform_url, :only => [:url]

  has_many :tagAppRelations, :foreign_key => "webapp_id", :dependent => :destroy
  has_many :tags, :through => :tagAppRelations , :source => :tag
  has_many :bookmarks, :foreign_key => "webapp_id", :dependent => :destroy
  #has_many :users, :through => :bookmarks , :source => :user
  has_many :comments , :dependent => :destroy
  belongs_to :user
  belongs_to :category
  
  url_regex  =  /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  accepts_nested_attributes_for :tags

  has_attached_file :photo, PAPERCLIP_STORAGE_WEBAPP ## This constant is defined in production.rb AND development.rb => be careful to change both ;)
  validates_attachment_size :photo, :less_than => 1.megabytes,:content_type => { :content_type => "image/jpg" }
  #validates_attachment_presence :photo # Comment because test fail otherwise !

  
  validates :title, :presence => true, :length => { :maximum => 25, :minimum => 2 }
  validates :caption, :presence => true, :length => { :maximum => 200, :minimum => 30 }
  validates :description, :presence => true,:length => { :maximum => 600, :minimum => 100 }
  validates :url, :presence => true,
    :format => {:with => url_regex },
    :uniqueness => true


  scope :validated, lambda { where("validate = '1'")}
  scope :unvalidated, lambda { where ("validate = '0'")}
  scope :promoted, lambda { where ("promoted = '1'")}
  scope :featured, lambda { where ("featured = '1'")}
  # return latest website inserted and validated
  scope :recent, lambda { |n| order("created_at").reverse_order.limit(n) }
  # return most consulted website
  scope :trend, lambda { |n| validated.order("nb_click_detail").reverse_order.limit(n) }
  scope :most_commented, lambda { |n| joins(:comments).where("comments.body != ''").order("count(comments.id)").group('webapps.id').reverse_order.limit(n)}
  scope :best_rated, lambda { |n| joins(:comments).order("avg(comments.rating)").group('webapps.id').reverse_order.limit(n)}
  scope :best_shared, lambda {|n| validated.order("nb_click_shared").reverse_order.limit(n) }
  scope :random, lambda {|n| validated.order("RANDOM()").limit(n) }

  @@score_for_validation = 5
  has_reputation :votes, source: :user, aggregated_by: :sum

  def score_for_validation
    @@score_for_validation
  end

  
  ##################
  ## TAGS METHODS ##
  ##################

  # Does this WebApp is tagged by 'tag' ?
  def tagged_by_tag?(name)
    tags.find_by_name(name)
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def add_tags(tags,user)
    if (tags.kind_of? Array)
      tags.each { |tag|
        return nil unless self.add_tag(tag,user)
      }
    else
      tags.split(",").uniq.map do |n|
        return nil unless self.add_tag(n.strip.to_s,user)
      end
    end
  end

  # Pour ajouter un tag a la webapp
  # Increment le coeff du tag si le website est deja taggué avec
  # Ajoute le tag en base s'il n'existe pas
  def add_tag(tag,user)
    if(tag.kind_of?(String))
      tagToAdd = Tag.where(name: tag.strip).first_or_create!
    else
      tagToAdd = Tag.where(name: tag.name.strip).first_or_create!
    end

    if(!TagAppRelation.find_by_user_id_and_tag_id_and_webapp_id(user.id,tagToAdd.id,self.id))
       TagAppRelation.create(:user_id=>user.id,:tag_id=>tagToAdd.id,:webapp_id => self.id).save
    else
      return nil
    end
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).webapps.validated
  end

  ## Best tag for this web app
  def n_best_tags(n)
    ## It's the most_posted tags along websites's tags
    tags.most_posted(n)
  end

  ###############################
  ## Getter virtual attributes ##
  ###############################

  def count_positive
    self.evaluations.where{(value == "1") }.length
  end

    def image_url(type)
        photo.url(type)
    end

  def count_negative
    self.evaluations.where{(value == "-1") }.length
  end

  def vote_user(user)
    return "up" if evaluations.where{(source_id == user.id) }.first.try(:value) == 1
    return "down" if evaluations.where{(source_id == user.id) }.first.try(:value) == -1
    return "none"
  end
  
  def nb_rating
    self.comments.all.length
  end

  def best_tags
    n_best_tags(3)
  end

  def preview
    self.photo.url(:small)
  end

  def reviews
    comments.commented.to_json(:include => :user)
  end

  def bookmarked?(webapp_id,user_id)
    return true if Bookmark.find_by_webapp_id_and_user_id(webapp_id, user_id)
    return false
  end

  def nb_comments
    comments.commented.count
  end
 
  def score
    score_click_detail = nb_click_detail * Webapp.score_weights['click_detail']
    score_comments = nb_comments * Webapp.score_weights['nb_comments']
    score_click_shared = nb_click_shared * Webapp.score_weights['click_shared']
    (score_click_detail + score_click_shared + score_comments) * average_rate
  end

  #######################
  ## Top sites Methods ##
  #######################

  def self.score_weights
      {
        'click_detail' => 2,
        'click_shared' => 10,
        'nb_comments' => 5
      }
  end

  # return three most comment
  def self.top_comment
    #TODO update after comment
    Webapp.find(:all, :order => "nb_click_url desc", :limit => 3)
  end

  ## To increment nb_click_<element>
  def increment_nb_click(hash)
    case hash[:element]
      when "detail"
        self.increment(:nb_click_detail).save
      when "preview"
        self.increment(:nb_click_preview).save
      when "url"
        self.increment(:nb_click_url).save
      when "shared"
        self.increment(:nb_click_shared).save
    end
  end

  def self.popular(n=4)
    scores = Hash.new
    Webapp.all.each do |w|
      scores[w.id] = w.score
    end
    # n % 4 must be 0
    r = n % 4
    n = n + (4 - r) unless (r == 0)
    # Construct new Hash with best n webapps
    best_apps = Hash[scores.sort_by { |key, value| value }.reverse[0..n-1]]
    best_apps.each do |k,v| puts "#{k} => #{v}" end
    Webapp.where(:id => [best_apps.keys])
  end

  ##############
  # Validation #
  ##############

  ## Validate and uniform
  ## Tres salasse à refaire
  def uniform_url
#    if(!self.url.index("www"))
#      return self.url.gsub("http://", "http://www.").downcase if self.url.index("http://")
#      return self.url.gsub("https://","https://www.").downcase if self.url.index("https://")
#      return self.url = "http://www." << self.url else
#    end
#    if(!self.url.index("http"))
#      return self.url.gsub("www.", "http://www.")
#    end
#
#    return self.url

  end

end
