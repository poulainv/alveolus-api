class Webapp < ActiveRecord::Base

  attr_accessible :average_rate, :caption, :description, :title, :url, :validate
  
  has_many :tagAppRelations, :foreign_key => "webapp_id", :dependent => :destroy
  has_many :tags, :through => :tagAppRelations , :source => :tag

  url_regex  = /((http:\/\/|https:\/\/)?(www.)?(([a-zA-Z0-9-]){2,}\.){1,4}([a-zA-Z]){2,6}(\/([a-zA-Z-_\/\.0-9#:?=&;,]*)?)?)/
  
  validates :title, :presence => true
  validates :caption, :presence => true
  validates :description, :presence => true
  validates :url, :presence => true,
    :format => {:with => url_regex }
  
  # Does this WebApp is tagged by 'tag' ?
  def taggedByTag?(tag)
    if(tag.kind_of? Tag)
      tags.find_by_id(tag.id)
    elsif(tag.kind_of? String)
      tags.find_by_name(tag)
    end
  end

  def addTags!(tags)
    if (tags.kind_of? Array)
      tags.each { |tag|
        if tag.kind_of? Tag
          self.addTag!(tag)
        end
        if tag.kind_of? String
          self.addTag!(tag)
        end
      }
    end
  end

  # Pour ajouter un tag a la webapp, ne fait rien s'il la webapp est deja taggué avec
  # Accepte un objet tag ou le nom d'un tag
  # Ajoute le tag en base s'il n'existe pas
  def addTag!(tag)
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
    
    return tagAppRelations.create!(:tag_id => tagToAdd.id) unless taggedByTag?(tagToAdd)
  end 
end
