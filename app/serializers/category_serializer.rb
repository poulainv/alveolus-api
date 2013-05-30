class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :featured_webapp, :description
  has_many :webapps

  def featured_webapp
  	object.featured_webapp
  end

end
