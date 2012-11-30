module WebAppsHelper

  def tronc_caption(text,n=100)
    res = text.slice(0,n)
    res<<"..." if n<text.length
    return res
  end

   def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
