class PagesController < ApplicationController
  def about
  	@titre = "A propos"
  end

  def contact
    
  end

  def faq
  	@titre = "FAQ"
  end
  
end
