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

  def display_title(title,small=false)
    if(small)
      if title.length>12
        "<h5> #{title} </h5>".html_safe
      else
        "<h4> #{title} </h4>".html_safe
      end
    else
      if title.length>12
        "<h4> #{title} </h4>".html_safe
      else
        "<h2> #{title} </h2>".html_safe
      end
    end

  end

  def vimeo_url(id)
    return "http://player.vimeo.com/video/#{id}"
  end

  def manage_button_up_vote(website)
    if website.vote_user(current_user) == "up"
      return "disabled"
    end
  end

  def manage_button_down_vote(website)
    if website.vote_user(current_user) == "down"
      return "disabled"
    end
  end
end
