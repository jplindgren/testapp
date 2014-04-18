class Micropost < ActiveRecord::Base
	belongs_to :user
  	attr_accessible :content

  	validates :content, :length => { maximum: 140 }
  	validates :user_id, presence: true
  	validates :content, presence: true

  	default_scope order: 'microposts.created_at DESC'

  	def self.from_users_followed_by user
  		#followed_users_ids = user.followed_users.map(&:id).join(', ')
  		#devido a contrução acima ser muito comum o rails já prove um alias followed_users_ids

  		#construção antiga
  		#followed_user_ids = user.followed_user_ids
  		#where("user_id IN (:followed_user_ids) OR user_id = :user_id", followed_user_ids: followed_user_ids, user_id: user)

  		#mas no tutorial ele acaba terminando com sql puro. Porque?
  		followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
  		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
  	end
end
