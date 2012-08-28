class User < ActiveRecord::Base
  has_many :authentications
  has_many :templates
  extend FriendlyId
  
  friendly_id :nickname
  acts_as_voter
  acts_as_taggable
  acts_as_taggable_on :tags
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nickname
  def apply_omniauth(omniauth)
    if email.blank?
      self.email = omniauth['info']['email'] if omniauth['info'] && omniauth['info']['email']
      self.email = omniauth['user_info']['email'] if omniauth['user_info'] && omniauth['user_info']['email']
      self.email = omniauth['extra']['raw_info']['email'] if omniauth['extra'] && omniauth['extra']['raw_info'] && omniauth['extra']['raw_info']['email']
    end
    auth = authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    auth.access_token = omniauth['credentials']['token']
    return auth
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def to_s
    if(nickname)
      return nickname
    else
      return "Anonymous artist"
    end
  end
end
