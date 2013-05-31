class Category < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :webapps

   # Return a random featured webapp for a category
   def featured_webapp(n=3)
    if Rails.env == "production"
    	self.webapps.where(:featured => true).order("RANDOM()").limit(n)
    else
    	self.webapps.where(:featured => true).order("RAND()").limit(n)
    end
  end

  def validated
    self.webapps.validated
  end

end


