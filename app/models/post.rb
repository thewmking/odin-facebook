class Post < ApplicationRecord
validates :content, presence: true, length: { maximum: 5000 }

belongs_to :user
has_many :likes

end
