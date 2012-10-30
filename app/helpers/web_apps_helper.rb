module WebAppsHelper

  # return three latest website inserted
  def get_top_recent
    # Some explainations :
    # we find in :all row
    # select only title and url attribute
    # by order desc
    # ...
    Webapp.find(:all, :select => "title, url", :order => "id desc", :limit => 3).reverse
  end

end
