class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :comments,:provider, :uid,:last_sign_in_at,:admin
  # attr_accessible :title, :body

  has_many :comments, :dependent => :destroy
  has_many :authentications


  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'] ,:token=> omniauth['credentials']['token'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end



end
