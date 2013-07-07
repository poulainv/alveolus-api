# encoding: utf-8
class NotificationsController < BaseController

  before_filter :user_needed!, :only => [:index, :unread, :reading]
  
 # GET notifications/
  def index
    @notifications = current_user.notifications
    render json: @notifications
  end

  def unread
    @notifications = current_user.notifications.unread
    render json: @notifications
  end

  def last
    @notifications = current_user.notifications.lastest(4)
    render json: @notifications
  end

  def reading
    @notifications = Notification.reading(current_user)
    render json: @notifications
  end

end
