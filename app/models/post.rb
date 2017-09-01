class Post < ApplicationRecord

  after_save :create_mentions
  #after_save :create_mention_links

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

  def create_mention_links
    content_words = self.content.split(" ")
    content_with_links = content_words.map do |word|
      if word.start_with?("@")
        mention = self.mentions.where(username: word.gsub('@', '')).first if @post.mentions.present?
        link_to mention.mentionee_id, user_path(mention.mentionee_id)
      else
        word
      end
    end
    self.content = content_with_links.join(" ")
    self.save
  end
end
