class CategoryAllSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :webapps, :each_serializer => WebappLazySerializer
  
end
