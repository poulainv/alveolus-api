class Comment < ActiveRecord::Base
  attr_accessible :body, :rating, :user_id, :webapp_id, :user, :webapp

  belongs_to :user
  belongs_to :webapp

  default_scope :order => 'comments.created_at DESC'

  after_save :update_website_add_rating
  before_destroy  :update_website_delete_rating
  validates :body, :length => { :maximum => 400 }
  validates :user_id, :presence => true
  validates :webapp_id, :presence => true
  validates_uniqueness_of :user_id, :scope => [:webapp_id]
  validates :rating, :presence => true, :inclusion => { :in => [1,2,3,4,5]}


  def update_website_add_rating
    @website = Webapp.find_by_id(self.webapp_id)
    new_rating = (@website.average_rate*(@website.comments.length-1)+self.rating)/(@website.comments.length)
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
end
