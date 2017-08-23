class Post < ApplicationRecord
validates :photo_url, presence: { if: -> {:content.blank?}},
                      format: { with: /\.(jpg|jpeg|gif|png)\z/ },
                      allow_blank: :true
validates :content,   presence: { if: -> {:photo_url.blank?}},
           length: { maximum: 5000 }

belongs_to :user
has_many :likes, dependent: :destroy
has_many :comments, dependent: :destroy

self.per_page = 10

end
