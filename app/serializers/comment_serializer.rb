class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :created_at
  has_one :user, :serializer => UserLazySerializer




end
