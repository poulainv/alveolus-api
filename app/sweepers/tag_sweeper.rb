class TagSweeper < ActionController::Caching::Sweeper
  observe TagAppRelation

  def after_create(tag)
     expire_fragment %r{tags*}
  end
 
  # If our sweeper detects that a Product was updated call this
  def after_update(tag)
    expire_fragment %r{tags*}
  end
 
  # If our sweeper detects that a Product was deleted call this
  def after_destroy(tag)
     expire_fragment %r{tags*}
  end
 


end