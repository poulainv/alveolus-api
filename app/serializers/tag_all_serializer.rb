class TagAllSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :webapps, :each_serializer => WebappLazySerializer
  
end
