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

  def display_title(title)
    if title.length>12
      "<h4> #{title} </h4>".html_safe
    else
        "<h2> #{title} </h2>".html_safe
    end
  end


end
