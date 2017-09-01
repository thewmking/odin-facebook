class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :notified_by, class_name: 'User'
  belongs_to :user
  belongs_to :post


  validates :user_id, :notified_by_id, :notice_type, presence: true

  def message
    user = self.notified_by.username
    if self.notice_type == 'post_mention'
      message = "#{user} mentioned you in a post"
    elsif self.notice_type == 'comment'
      message = "#{user} commented on your post"
    elsif self.notice_type == 'comment_mention'
      message = "#{user} mentioned you in a comment"
    elsif self.notice_type == 'like'
      message = "#{user} liked your post"
    elsif self.notice_type == 'friend request'
      message = "#{user} sent you a friend request"
    elsif self.notice_type == 'friend accept'
      message = "#{user} accepted your friend request"
    end
    message
  end

  def link_path
    if self.notice_type.in?(['post_mention', 'comment', 'comment_mention', 'like'])
      path = post_path(self.post_id)
    elsif self.notice_type == 'friend request'
      path = users_path
    elsif self.notice_type == 'friend accept'
      path = user_path(self.notified_by_id)
    end
    path
  end

  def style
    if self.post.photo_url.present?
      style = "background-image: url(#{self.post.photo_url}); color: white;
               text-shadow: 2px 2px 4px #000;"
    end
  end
end
