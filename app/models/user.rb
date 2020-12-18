class User < ApplicationRecord

  after_create :build_profile
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]

  # PROFILE ASSOCIATION
  has_one :profile, dependent: :destroy 

  # POSTS ASSOCIATION
  has_many :authored_posts, class_name: "Post", foreign_key: "author_id", dependent: :destroy

  # LIKES ASSOCIATION
  has_many :likes, dependent: :destroy

  # COMMENTS ASSOCIATION
  has_many :comments, dependent: :destroy

  # FRIENDSHIPS ASSOCIATION
  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy 
  has_many :inverse_friends, through: :inverse_friendships, source: :user



  # FRIENDS

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array += inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    friends_array.compact 
  end

  def pending_friends
    friendships.map { |friendship| friendship.friend if !friendship.confirmed }.compact 
  end 

  def friend_requests
    inverse_friendships.map{ |friendship| friendship if !friendship.confirmed }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |friendship| friendship.user == user }
    friendship.confirmed = true
    friendship.save 
  end

  def friend? 
    friends.include?(user)
  end

  # PROFILE

  def build_profile
    Profile.create(user: self)
  end

  # OMNIAUTH

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  # MAILER 

  after_create :sign_up_send
  
  def sign_up_send
    RegistrationMailer.sign_up(self).deliver
  end
end
