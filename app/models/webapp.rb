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

  attr_accessible :average_rate,:photo,:comments,:tags,:tag_list,:nb_click_preview, :promoted,  :nb_click_url,:nb_click_detail,:caption, :suggested,:description, :title, :url, :validate

  before_validation :uniform_url, :only => [:url]

  has_many :tagAppRelations, :foreign_key => "webapp_id", :dependent => :destroy
  has_many :tags, :through => :tagAppRelations , :source => :tag
  has_many :comments , :dependent => :destroy
  
  url_regex  = /((http:\/\/|https:\/\/)?(www.)?(([a-zA-Z0-9-]){2,}\.){1,4}([a-zA-Z]){2,6}(\/([a-zA-Z-_\/\.0-9#:?=&;,]*)?)?)/
  accepts_nested_attributes_for :tags

  has_attached_file :photo, PAPERCLIP_STORAGE ## This constant is defined in production.rb AND development.rb => be careful to change both ;)
  validates_attachment_size :photo, :less_than => 2.megabytes
  #validates_attachment_presence :photo # Comment because test fail otherwise !

  
  validates :title, :presence => true
  validates :caption, :presence => true
  validates :description, :presence => true
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

  def add_tags(tags)
    if (tags.kind_of? Array)
      tags.each { |tag|
        self.add_tag(tag)
      }
    else
      tags.split(",").uniq.map do |n|
        self.add_tag(n.strip.to_s)
      end
    end
  end

  # Pour ajouter un tag a la webapp
  # Increment le coeff du tag si le website est deja taggué avec
  # Ajoute le tag en base s'il n'existe pas
  def add_tag(tag)
    if(tag.kind_of?(String))
      tagToAdd = Tag.where(name: tag.strip).first_or_create!
    else
      tagToAdd = Tag.where(name: tag.name.strip).first_or_create!
    end

    if(!tagged_by_tag?(tagToAdd.name))
      self.tags += [tagToAdd]
    else
      self.tagAppRelations.find_by_tag_id(tagToAdd.id).increment(:coeff).save
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

  def n_best_tags(n)
   tags.order("tag_app_relations.coeff").reverse_order.limit(n)
  end


  ## Getter virtual attributes
  def nb_rating
    self.comments.all.length
  end

  def best_tags
   n_best_tags(3)
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
    end
  end

  ##############
  # Validation #
  ##############

  ## Validate and uniform
  ## Tres salasse à refaire
  def uniform_url
    if(!self.url.index("www"))
      return self.url.gsub("http://", "http://www.").downcase if self.url.index("http://")
      return self.url.gsub("https://","https://www.").downcase if self.url.index("https://")
      return self.url = "http://www." << self.url else
    end
    if(!self.url.index("http"))
      return self.url.gsub("www.", "http://www.")
    end

    return self.url
  
  end

end
