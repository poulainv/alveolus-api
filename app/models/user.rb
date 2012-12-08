class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable


  # Setup accessible (or protected) attributes for your model
  attr_accessible   :pseudo, :avatar,:email, :password, :password_confirmation, :tagUserRelations,:remember_me, :comments,:provider, :uid,:last_sign_in_at,:admin

  has_attached_file :avatar,  :styles => { :small => "75x75#", :mini=>"50x50#"},:default_url => "/img/avatar.jpg" ## This constant is defined in production.rb AND development.rb => be careful to change both ;)
  validates_attachment_size :avatar, :less_than => 1.megabytes,:content_type => { :content_type => "image/jpg" }

  has_many :comments, :dependent => :destroy
  has_many :authentications
 
  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    self.pseudo =  omniauth['info']['nickname'] if pseudo.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'] ,:token=> omniauth['credentials']['token'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end


  ## virtual attributes
  def image
    self.avatar.url(:mini)
  end


end
