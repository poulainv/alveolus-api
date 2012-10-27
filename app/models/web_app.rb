class WebApp < ActiveRecord::Base
  attr_accessible :average_rate, :caption, :description, :title, :url, :validate
  
  has_many :tagAppRelations, :foreign_key => "webapp_id", :dependent => :destroy
  has_many :tags, :through => :tagAppRelations , :source => :tag
     
  validates :title, :presence => true
  validates :caption, :presence => true
  validates :description, :presence => true
  validates :url, :presence => true
  validates :validate, :presence => true
  
  # Does this WebApp is tagged by 'tag' ?
  def taggedByTag?(tag)
     if(tag.kind_of? Tag)
       tags.find_by_id(tag.id)
     elsif(tag.kind_of? String)
        tags.find_by_name(tag)
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
