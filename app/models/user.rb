class User < ActiveRecord::Base
	has_many :microposts

	before_save { email.downcase! }
	
  	attr_accessible :email, :name, :password, :password_confirmation

  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  	validates :name, presence: true, :length => { maximum: 50 } 
  	validates :email, presence: true, 
  					  format: { with: VALID_EMAIL_REGEX }, 
  					  uniqueness: { case_sensitive: false }

  	has_secure_password
  	validates :password, :length => { :minimum => 6 }
end
