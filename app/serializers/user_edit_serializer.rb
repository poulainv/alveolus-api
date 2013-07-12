class UserEditSerializer < ActiveModel::Serializer
  attributes :id,:pseudo, :created_at, :email, :admin, :sign_in_count,:image_url

def image_url
		object.image_url(:small)
end

end
