class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, 
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessible   :pseudo, :avatar,:email, :password, :password_confirmation, :tagUserRelations,:remember_me, :comments,:provider, :uid,:last_sign_in_at,:admin

  has_attached_file :avatar,  PAPERCLIP_STORAGE_AVATAR ## This constant is defined in production.rb AND development.rb => be careful to change both ;)
  validates_attachment_size :avatar, :less_than => 1.megabytes,:content_type => { :content_type => "image/jpg" }

  has_many :comments, :dependent => :destroy
  has_many :authentications, :dependent => :destroy
  has_many :webapps
  has_many :bookmarks, :foreign_key => "user_id", :dependent => :destroy
  has_many :webapps_starred, :through => :bookmarks, :source => :webapp

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
