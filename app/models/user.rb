class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :omniauthable,
         :omniauth_providers => [:facebook]

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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
