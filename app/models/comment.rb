class Comment < ActiveRecord::Base
  attr_accessible :body, :rating, :user_id, :webapp_id, :user, :webapp

  belongs_to :user
  belongs_to :webapp

  default_scope :order => 'comments.created_at DESC'

  validates :body, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

end
