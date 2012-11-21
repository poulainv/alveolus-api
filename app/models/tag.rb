# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ActiveRecord::Base
  attr_accessible :name,:tagAppRelations,:tagUserRelations
  
  has_many :tagAppRelations, :foreign_key => "tag_id", :dependent => :destroy
  has_many :tagUserRelations, :dependent => :destroy
  has_many :webapps, :through => :tagAppRelations, :source => :webapp

  ## Most used tags for all website for example
  scope :most_used, lambda { |n| joins(:tagAppRelations).order("count(tag_app_relations.webapp_id)").group('tags.id').reverse_order.limit(n)}

  ## Most posted tags for one website 
  scope :most_posted, lambda { |n| joins(:tagAppRelations).order("count(tag_app_relations.id)").group('tags.id').reverse_order.limit(n)}

  accepts_nested_attributes_for :tagAppRelations


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
