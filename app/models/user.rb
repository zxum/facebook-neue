class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # PROFILE ASSOCIATION
  has_one :profile

  # POSTS ASSOCIATION
  has_many :authored_posts, class_name: "Post", foreign_key: "author_id"

  # LIKES ASSOCIATION
  has_many :likes, dependent: :destroy

  # COMMENTS ASSOCIATION
  has_many :comments, dependent: :destroy

  # FRIENDSHIPS ASSOCIATION
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'



  # FRIENDS

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array + inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    friends_array.compact 
  end

  def pending_friends
    friendships.map { |friendship| friendship.friend if !friendship.confirmed }.compact 
  end 

  def friend_requests
    inverse_friendships.map{ |friendship| friendship.user if !friendship.confirmed }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |friendship| friendship.user == user }
    friendship.confirmed = true
    friendship.save 
  end

  def friend? 
    friends.include?(user)
  end
end
