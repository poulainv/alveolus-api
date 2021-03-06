class WebappLazySerializer < ActiveModel::Serializer
  attributes :id,:caption,:title,:description, :featured,:created_at, :average_rate,:image_url,:category_id,:nb_click_preview, :nb_comments, :facebook_id,:twitter_id, :gplus_id,:vimeo_id,:user_id, :nb_click_url,:nb_click_shared,:nb_click_detail,:url, :validate, :category_id
  # has_many :comments, embed: :ids, :key => :comments
  attribute :tags
  has_one :category, :serializer => CategoryLazySerializer

  def image_url
  	object.image_url(:medium)
  end

  
  def tags
    object.best_tags
  end

end
