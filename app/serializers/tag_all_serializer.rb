class TagAllSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :webapps, :serializer => WebappLazySerializer
  
end
