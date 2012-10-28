class Tag < ActiveRecord::Base
  attr_accessible :name
  
  has_many :tagAppRelations, :foreign_key => "tag_id", :dependent => :destroy
  has_many :webapps, :through => :tagAppRelations, :source => :webapp
       
  # Does this tag tag 'webapp' ? 
  def tagged?(webapp)
    webapps.find_by_id(webapp.id)
  end

end
