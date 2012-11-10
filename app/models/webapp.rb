# == Schema Information
#
# Table name: webapps
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  caption          :string(255)
#  description      :string(255)
#  validate         :boolean
#  url              :string(255)
#  average_rate     :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string(255)
#  nb_click_preview :integer
#  nb_click_detail  :integer
#  nb_click_url     :integer
#

class Webapp < ActiveRecord::Base

  attr_accessible :average_rate, :nb_click_preview, :nb_click_url,:nb_click_detail,:caption, :description, :title, :url, :validate

  before_validation :uniform_url, :only => [:url]

  has_many :tagAppRelations, :foreign_key => "webapp_id", :dependent => :destroy
  has_many :tags, :through => :tagAppRelations , :source => :tag

  url_regex  = /((http:\/\/|https:\/\/)?(www.)?(([a-zA-Z0-9-]){2,}\.){1,4}([a-zA-Z]){2,6}(\/([a-zA-Z-_\/\.0-9#:?=&;,]*)?)?)/
  
  validates :title, :presence => true
  validates :caption, :presence => true
  validates :description, :presence => true
  validates :url, :presence => true,
    :format => {:with => url_regex },
    :uniqueness => true

  # Does this WebApp is tagged by 'tag' ?
  def tagged_by_tag?(tag)
    if(tag.kind_of? Tag)
      tags.find_by_id(tag.id)
    elsif(tag.kind_of? String)
      tags.find_by_name(tag)
    end
  end

  def add_tags!(tags)
    if (tags.kind_of? Array)
      tags.each { |tag|
        if tag.kind_of? Tag
          self.add_tag!(tag)
        end
        if tag.kind_of? String
          self.add_tag!(tag)
        end
      }
    end
  end

  # Pour ajouter un tag a la webapp, ne fait rien s'il la webapp est deja taggué avec
  # Accepte un objet tag ou le nom d'un tag
  # Ajoute le tag en base s'il n'existe pas
  def add_tag!(tag)
    nameTag = nil
    tagToAdd = nil
    
    if(tag.kind_of? String)
      nameTag = tag
      tagToAdd = Tag.find_by_name(nameTag);
    elsif(tag.kind_of? Tag)
      tagToAdd = Tag.find_by_id(tag.id)
      nameTag = tag.name
    end
    
    if(tagToAdd == nil)
      tagToAdd = Tag.create(:name=>nameTag)
      tagToAdd.save
    end
    
    return tagAppRelations.create!(:tag_id => tagToAdd.id) unless tagged_by_tag?(tagToAdd)
  end



  ## Top Methods
  # return three latest website inserted
  def self.top_recent
    # Some explainations :
    # we find in :all row
    # select only title and url attribute
    # by order desc
    # ...
    Webapp.last(3)
  end

  # return three most consult
  def self.top_trend
    Webapp.find(:all, :order => "nb_click_preview desc", :limit => 3).reverse
  end

  # return three most comment
  def self.top_comment
    #TODO update after comment
    Webapp.find(:all, :order => "nb_click_url desc", :limit => 3).reverse
  end


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
