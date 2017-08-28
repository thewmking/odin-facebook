class Comment < ApplicationRecord

  after_save :create_mentions

  act_as_mentioner

  belongs_to :post
  belongs_to :user

  validates  :content, presence: true

  def create_mentions
    m = CustomMentionProcessor.new
    m.process_mentions(self)
  end

end
