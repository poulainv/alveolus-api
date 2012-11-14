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

  attr_accessible :average_rate,:photo,:tags,:tag_list,:nb_click_preview, :promoted,  :nb_click_url,:nb_click_detail,:caption, :description, :title, :url, :validate

  before_validation :uniform_url, :only => [:url]

  has_many :tagAppRelations, :foreign_key => "webapp_id", :dependent => :destroy
  has_many :tags, :through => :tagAppRelations , :source => :tag
  
  
  url_regex  = /((http:\/\/|https:\/\/)?(www.)?(([a-zA-Z0-9-]){2,}\.){1,4}([a-zA-Z]){2,6}(\/([a-zA-Z-_\/\.0-9#:?=&;,]*)?)?)/
  accepts_nested_attributes_for :tags
  has_attached_file :photo, :styles => { :caroussel => "550x350!"}
  validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_presence :photo

  
  validates :title, :presence => true
  validates :caption, :presence => true
  validates :description, :presence => true
  validates :url, :presence => true,
    :format => {:with => url_regex },
    :uniqueness => true


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
      self.tags += tags.split(",").uniq.map do |n|
        Tag.where(name: n.strip).first_or_create!
      end
    end
  end

  # Pour ajouter un tag a la webapp, ne fait rien s'il la webapp est deja taggué avec
  # Accepte un objet tag ou le nom d'un tag
  # Ajoute le tag en base s'il n'existe pas
  def add_tag(tag)
    if(tag.kind_of?(String))
      tagToAdd = Tag.where(name: tag.strip).first_or_create!
    else
      tagToAdd = Tag.where(name: tag.name.strip).first_or_create!
    end
    return tagAppRelations.create!(:tag_id => tagToAdd.id) unless tagged_by_tag?(tagToAdd.name)
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end


  def self.tagged_with(name)
    Tag.find_by_name!(name).webapps
  end


  #######################
  ## Top sites Methods ##
  #######################

  # return three latest website inserted
  def self.top_recent
    Webapp.last(3)
  end

  # return three most consult
  def self.top_trend
    Webapp.find(:all, :order => "nb_click_detail desc", :limit => 3)
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
      old_value = self.nb_click_detail
    when "preview"
      old_value = self.nb_click_preview
    when "url"
      old_value = self.nb_click_url
    end
    self.update_attribute("nb_click_"+hash[:element], old_value+1)
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
