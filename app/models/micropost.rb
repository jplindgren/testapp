class Micropost < ActiveRecord::Base
	belongs_to :user
  	attr_accessible :content

  	validates :content, :length => { maximum: 140 }
  	validates :user_id, presence: true
  	validates :content, presence: true

  	default_scope order: 'microposts.created_at DESC'
end
