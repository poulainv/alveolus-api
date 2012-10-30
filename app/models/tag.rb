class Tag < ActiveRecord::Base
  attr_accessible :name
  
  has_many :tagAppRelations, :foreign_key => "tag_id", :dependent => :destroy
  has_many :webapps, :through => :tagAppRelations, :source => :webapp
    
  # Does this tag tag 'webapp' ? 
  def tagged?(webapp)
    webapps.find_by_id(webapp.id)
  end

  # Return array of tags associated through their webapps
  # Note : we can probably improve complexity of this method
  def tags_associated
    @tagsResult = Array.new
    webapps.each { |webapp|
      puts webapp.title
      webapp.tags.each { |tag|
        puts tag.name
        @tagsResult.insert(@tagsResult.length-1,tag) unless @tagsResult.include? tag
      }
    }
    return @tagsResult
  end

end
