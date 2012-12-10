class Bookmark < ActiveRecord::Base
  attr_accessible :user_id, :webapp_id

  belongs_to :user, :class_name => "User"
  belongs_to :webapp, :class_name => "Webapp"

  validates :user_id, :presence => true
  validates :webapp_id, :presence => true
  validates_uniqueness_of :user_id, :scope => [:webapp_id]
end
