class User < ApplicationRecord

  after_save :convert_spaces

  enum role: [:user, :admin]

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :omniauthable,
         :omniauth_providers => [:facebook]

  act_as_mentionee

  has_many :posts,         dependent: :destroy
  has_many :comments,      dependent: :destroy
  has_many :likes,         dependent: :destroy
  has_many :friendships,   dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :received_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :active_friends,        -> { where(friendships: { accepted: true }) },
           through: :friendships, source: :friend
  has_many :received_friends,      -> { where(friendships: { accepted: true }) },
           through: :received_friendships, source: :user
  has_many :pending_friends,       -> { where(friendships: { accepted: false }) },
           through: :friendships, source: :friend
  has_many :requested_friendships, -> { where(friendships: { accepted: false }) },
           through: :received_friendships, source: :user

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>", mini: "50x50>"},
                    default_url: "/images/:style/missing.png"

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def set_default_role
    self.role ||= :user
  end

  def is_admin?
    self.role == "admin"
  end

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
      user.username = auth.info.name.gsub(' ', '_')   # assuming the user model has a name
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

  self.per_page = 10

  private

  def convert_spaces
    if self.username.include?(' ')
      user_name = self.username.gsub(' ', '_')
      self.update(username: user_name)
    end
  end
end
