module UsersHelper

  def photo_url(user)
    return user.avatar.url(:mini) if !user.avatar.blank?
    #return "http://graph.facebook.com/#{user.pseudo}/picture?type=small" if !user.provider.blank?
    return "/img/avatar.jpg"
  end

end
