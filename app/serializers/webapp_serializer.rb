class WebappSerializer < ActiveModel::Serializer
  attributes :id,:caption,:title,:description, :featured, :created_at, :average_rate,:nb_click_shared, :nb_bookmarks, :image_url,:category_id,:nb_click_preview, :facebook_id,:twitter_id, :gplus_id,:vimeo_id,:user_id, :nb_click_url,:nb_click_detail,:url, :validate, :category_id
  attribute :bookmarked
  has_many :comments, :serializer => CommentSerializer
  attribute :tags,  :serializer => TagSerializer
  has_one :category, :serializer => CategoryLazySerializer
  has_one :user, :serializer => UserLazySerializer

  def image_url
  	object.image_url(:medium)
  end

  def bookmarked
  	return object.bookmarked?(object.id,current_user.id) if current_user
  end
  
  def tags
    object.best_tags
  end
end
