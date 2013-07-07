class Notification < ActiveRecord::Base
  attr_accessible :date_readed, :is_readed, :text, :user_id, :path_action

  belongs_to :user

  scope :unread, lambda { where("is_readed = '0'")}
  scope :lastest, lambda { |n| limit(n).order('notifications.created_at DESC')}

  def self.reading(user)
  	user.notifications.unread.each do |notif|
  		notif.is_readed = true
      notif.date_reading = Time.new
  		notif.save!
  	end
  	return user.notifications.lastest(4)
  end
  
end
