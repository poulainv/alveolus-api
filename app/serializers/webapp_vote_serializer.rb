class WebappVoteSerializer < ActiveModel::Serializer
  attributes :id,:caption,:title,:description,:average_rate,:image_url,:count_positive,:count_negative,:my_vote, :facebook_id,:twitter_id, :gplus_id,:vimeo_id,:user_id, :nb_click_url,:nb_click_detail,:url, :validate, :category_id
  has_many :comments, embed: :ids, :key => :comments
  has_many :tags
  has_one :category, :serializer => CategoryLazySerializer

  def image_url
  	object.image_url(:medium)
  end

	def count_positive
		object.count_positive
	end

	def count_negative
		object.count_negative
	end

	def my_vote
		object.vote_user(current_user) if current_user
	end

end
