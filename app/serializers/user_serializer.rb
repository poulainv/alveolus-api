class UserSerializer < ActiveModel::Serializer
  attributes :id,:pseudo, :created_at, :admin, :sign_in_count,:image_url
  has_many :webapps
  has_many :comments
  has_many :webapps_starred, :key => :bookmarks

def image_url
		object.image_url(:small)
end

end
