class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :webapps

   # Return a random featured webapp for a category
  def featuredWebapp
    self.webapps.where(:featured => true).order("RAND()").first
  end
end
