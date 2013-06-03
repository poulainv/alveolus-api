class UserLazySerializer < ActiveModel::Serializer
  attributes :id,:pseudo, :image_url

	def image_url
		object.image_url(:small)
	end
end
