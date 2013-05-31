class CategoryAllSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :webapps, :serializer => WebappLazySerializer
  
end
