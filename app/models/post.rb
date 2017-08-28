class Post < ApplicationRecord

  after_save :create_mentions

  validates :photo_url, presence: { if: -> {:content.blank?}},
                        format: { with: /(?:([^:\/?#]+):)?(?:\/\/([^\/?#]*))?([^?#]*\.(?:jpg|jpeg|gif|png))(?:\?([^#]*))?(?:#(.*))?/ },
                        allow_blank: :true
  validates :content,   presence: { if: -> {:photo_url.blank?}},
             length: { maximum: 5000 }

  act_as_mentioner

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  self.per_page = 10

  def create_mentions
    m = CustomMentionProcessor.new
    m.process_mentions(self)
  end
end
