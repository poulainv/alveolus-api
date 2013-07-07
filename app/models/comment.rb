  # encoding: utf-8

class Comment < ActiveRecord::Base
  attr_accessible :body, :rating, :user_id, :webapp_id, :user, :webapp

  after_commit :notify_new_comment

  belongs_to :user
  belongs_to :webapp
  ## A comments is a rating with optional text, this scope return only comments with text field
  scope :commented, lambda { where("body <> ''").order('comments.created_at DESC') }
  ## All comments

  scope :rating, lambda {order('comments.created_at DESC') }
  default_scope :order => "comments.created_at DESC"
  
  after_save :update_website_add_rating
  before_destroy  :update_website_delete_rating
  validates :body, :length => { :maximum => 400 }
  validates :user_id, :presence => true
  validates :webapp_id, :presence => true
  validates_uniqueness_of :user_id, :scope => [:webapp_id]
  validates :rating, :presence => true, :inclusion => { :in => [1,2,3,4,5]}

 
  def update_website_add_rating
    @website = Webapp.find_by_id(self.webapp_id)
    if(@website.comments.length ==1)
      new_rating = self.rating;
    else
    new_rating = (@website.average_rate*(@website.comments.length-1)+self.rating)/(@website.comments.length)
      end
      @website.average_rate = new_rating;
    @website.save
  end

  def update_website_delete_rating
    if(@website = Webapp.find_by_id(self.webapp_id))
      if(@website.comments.length==1)
        new_rating = 0;
      else
         new_rating = (@website.average_rate*(@website.comments.length)-self.rating)/(@website.comments.length-1)
      end
      @website.average_rate = new_rating;
      @website.save
    end
  end

  
  def notify_new_comment
    users_notified = Hash.new
    users_notified[user.id] = true
    ## Notify all others commenters
    self.webapp.comments.each do |c|
      if !users_notified.has_key? c.user.id
        @notifications = c.user.notifications.build(:text => "#{self.user.pseudo} a commenté la même alvéole que vous.",:path_action => "/alveoles/#{self.webapp.id}")
        @notifications.save!
        users_notified[c.user.id] = true ## Check syntax
      end
    end

    ## Notify alveole owner
    if !(users_notified.key? self.webapp.try(:user).try(:id)) && self.webapp.user
        @notifications = self.webapp.user.notifications.build(:text => "#{self.user.pseudo} a commenté votre alvéole.",:path_action => "/alveoles/#{self.webapp.id}")
        @notifications.save!
        users_notified[self.webapp.user.id] = true
    end

     ## Notify alveolus' admin
    User.all_admin.each do |u|
      if !users_notified.key?  u.id
          @notifications = u.notifications.build(:text => "#{self.user.pseudo} a commenté une alvéole.",:path_action => "/alveoles/#{self.webapp.id}")
          @notifications.save!
          users_notified[u.id] = true
      end
    end
   end
end
