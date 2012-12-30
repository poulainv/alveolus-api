module ApplicationHelper

  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end

  def total_website
    Webapp.validated.try(:length)
  end

  def total_comment
    Comment.all.try(:length)
  end

  def total_unvalidated
    Webapp.unvalidated.try(:length)
  end

  def total_user
    User.all.try(:length)
  end

  def total_sharing
   # Webapp.validated.inject(0){ |sum,n| sum+n.nb_click_shared}
102
  end

end


