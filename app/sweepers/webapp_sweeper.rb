class WebappSweeper < ActionController::Caching::Sweeper
  observe Webapp

  def after_create(webapp)
     expire_fragment %r{webapps*}
  end
 
  
  def after_update(webapp)
    # expire_fragment %r{webapps}
  end
 

  def after_destroy(webapp)
     expire_fragment %r{webapps*} #supprime aussi le cache pour category...
  end


end