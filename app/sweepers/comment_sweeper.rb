class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment

  def after_create(comment)
   expire_fragment %r{/webapps*}
   expire_fragment %r{comments*}
 end
 

 def after_update(webapp)
  expire_fragment %r{/webapps*}
  expire_fragment %r{comments*}
end


def after_destroy(webapp)
  expire_fragment %r{/webapps*}
  expire_fragment %r{comments*}
end



end