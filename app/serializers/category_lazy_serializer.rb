class CategoryLazySerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  attribute :featured_webapp, :key => :webapps

   def featured_webapp
  	object.featured_webapp
  end

end
