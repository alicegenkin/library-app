class User < ApplicationRecord
  has_secure_password
  has_many :ratings
  has_many :books, through: :ratings
  validates :username, presence: true
  #validates :username, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
 #validates :password, presence: true
 

  def self.create_from_omniauth(auth)
    User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.username = auth['info']['name']
      u.email = auth['info']['email'] 
      u.password = SecureRandom.hex(16)
    end
  end
end
