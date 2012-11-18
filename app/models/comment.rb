class Comment < ActiveRecord::Base
  attr_accessible :body, :rating, :user_id, :webapp_id, :user, :webapp

  belongs_to :user
  belongs_to :webapp

  default_scope :order => 'comments.created_at DESC'

  validates :body, :length => { :maximum => 400 }
  validates :user_id, :presence => true
  validates :webapp_id, :presence => true
  validates_uniqueness_of :user_id, :scope => [:webapp_id]
  validates :rating, :presence => true, :inclusion => { :in => [1,2,3,4,5]}
end
