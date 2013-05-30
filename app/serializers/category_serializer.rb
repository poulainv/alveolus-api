class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  # has_many :webapps
  has_many :featured_webapp, :key => :webapps, :serializer => WebappLazySerializer

   def featured_webapp
  	object.featured_webapp
  end

end
