class PagesController < ApplicationController
  def about
  	@titre = "A propos"
  end

  def contact
  	@titre = "Contact"
  end
  
   def actualites
   	@titre = "Actualites"
   end
end
