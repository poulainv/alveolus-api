class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :created_at, :webapp_id, :webapp_image_url, :webapp_title
  has_one :user, :serializer => UserLazySerializer
 
def webapp_id
	object.webapp.id
end

def webapp_image_url
	webapp = object.webapp.photo(:small)
end

def webapp_title
	object.webapp.title
end



end
