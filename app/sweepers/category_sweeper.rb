class CategorySweeper < ActionController::Caching::Sweeper
  observe Comment

 #  def after_create(category)
 #   expire_fragment %r{webapps*}
 #   expire_fragment %r{categories*}
 # end
 
 
#  def after_update(category)
#   expire_fragment %r{webapps*}
#   expire_fragment %r{categories*}
# end

## Absurde, mais c'est juste pour contrôler qd on veut clear les caches...
def after_destroy(comment)
  expire_fragment %r{categories*}
end



end