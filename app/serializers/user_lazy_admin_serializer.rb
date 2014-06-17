class UserLazyAdminSerializer < ActiveModel::Serializer
  attributes :id,:pseudo, :image_url, :email

	def image_url
		object.image_url(:small)
	end
end
