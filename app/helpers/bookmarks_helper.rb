module BookmarksHelper

  def bookmarked?(user,webapp)
    return false if Bookmark.find_all_by_user_id_and_webapp_id(user.id,webapp.id).length == 0
    return true
  end


end
