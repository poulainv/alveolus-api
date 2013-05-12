class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :webapps

   # Return a random featured webapp for a category
  def featured_webapp(n)
    if Rails.env == "production"
    	self.webapps.where(:featured => true).order("RANDOM()").limit(n)
    else
    	self.webapps.where(:featured => true).order("RAND()").limit(n)
    end
  end

end


