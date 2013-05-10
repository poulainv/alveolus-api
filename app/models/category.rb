class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :webapps

   # Return a random featured webapp for a category
  def featuredWebapp
  	if Rails.env == "development"
    	self.webapps.where(:featured => true).order("RAND()").first
    elsif Rails.env == "production"
    	self.webapps.where(:featured => true).order("RANDOM()").first
    end
  end
end
