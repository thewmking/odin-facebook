class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable

  has_many :posts,    dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy
  has_many :friendships
  has_many :friends,  :through => :friendships

  def likes?(post_id)
    liked_post_ids = []
    self.likes.each do |l|
      liked_post_ids << l.post_id
    end
    post_id.in?(liked_post_ids)
  end
end
