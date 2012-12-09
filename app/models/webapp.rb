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

  attr_accessible :average_rate,:user_id,:photo,:comments,:tags,:tag_list,:nb_click_preview, :promoted,  :nb_click_url,:nb_click_detail,:caption, :suggested,:description, :title, :url, :validate

  before_validation :uniform_url, :only => [:url]

  has_many :tagAppRelations, :foreign_key => "webapp_id", :dependent => :destroy
  has_many :tags, :through => :tagAppRelations , :source => :tag
  has_many :comments , :dependent => :destroy
  belongs_to :user
  
  url_regex  =  /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  accepts_nested_attributes_for :tags

  has_attached_file :photo, PAPERCLIP_STORAGE_WEBAPP ## This constant is defined in production.rb AND development.rb => be careful to change both ;)
  validates_attachment_size :photo, :less_than => 1.megabytes,:content_type => { :content_type => "image/jpg" }
  #validates_attachment_presence :photo # Comment because test fail otherwise !

  
  validates :title, :presence => true, :length => { :maximum => 25, :minimum => 2 }
  validates :caption, :presence => true, :length => { :maximum => 170, :minimum => 30 }
  validates :description, :presence => true,:length => { :maximum => 600, :minimum => 100 }
  validates :url, :presence => true,
    :format => {:with => url_regex },
    :uniqueness => true


  scope :validated, lambda { where("validate = '1'")}
  scope :unvalidated, lambda { where ("validate = '0'")}
  scope :promoted, lambda { where ("promoted = '1'")}
  scope :suggested, lambda { where ("suggested = '1'")}
  # return latest website inserted and validated
  scope :recent, lambda { |n| validated.order("created_at").reverse_order.limit(n) }
  # return most consulted website
  scope :trend, lambda { |n| validated.order("nb_click_detail").reverse_order.limit(n) }
  scope :most_commented, lambda { |n| joins(:comments).order("count(comments.id)").group('webapps.id').reverse_order.limit(n)}
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
    Tag.find_by_name!(name).webapps
  end

  ## Best tag for this web app
  def n_best_tags(n)
    ## It's the most_posted tags along websites's tags
    tags.most_posted(n)
  end

  ###############################
  ## Getter virtual attributes ##
  ###############################

  
  def nb_rating
    self.comments.all.length
  end

  def best_tags
    n_best_tags(5)
  end


  def preview
    self.photo.url(:small)
  end

  def reviews
    comments.commented.to_json(:include => :user)
  end

 




  #######################
  ## Top sites Methods ##
  #######################


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
