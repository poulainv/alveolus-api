class TagAppRelation < ActiveRecord::Base
  attr_accessible :tag_id, :webapp_id
  
  belongs_to :tag, :class_name => "Tag"
  belongs_to :webapp, :class_name => "WebApp"
 
  validates :tag_id, :presence => true
  validates :webapp_id, :presence => true
end
