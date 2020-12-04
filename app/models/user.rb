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

end
