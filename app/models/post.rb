class Post < ApplicationRecord
validates :photo_url, presence: { if: -> {:content.blank?}}
validates :content,   presence: { if: -> {:photo_url.blank?}},
           length: { maximum: 5000 }

belongs_to :user
has_many :likes
has_many :comments

end
