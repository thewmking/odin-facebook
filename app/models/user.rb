class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable

  has_many :posts,    dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy
  has_many :friendships
  has_many :received_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :active_friends,        -> { where(friendships: { accepted: true }) },
           through: :friendships, source: :friend
  has_many :received_friends,      -> { where(friendships: { accepted: true }) },
           through: :received_friendships, source: :user
  has_many :pending_friends,       -> { where(friendships: { accepted: false }) },
           through: :friendships, source: :friend
  has_many :requested_friendships, -> { where(friendships: { accepted: false }) },
           through: :received_friendships, source: :user

  def likes?(post_id)
    liked_post_ids = []
    self.likes.each do |l|
      liked_post_ids << l.post_id
    end
    post_id.in?(liked_post_ids)
  end

  def friends
    active_friends | received_friends
  end

  def pending
    pending_friends | requested_friendships
  end

  def current_friendship
    self.friendships.find_by(user_id: self.id, friend_id: current_user.id)
  end
end
