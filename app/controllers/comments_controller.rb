class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action  :mention_notifications, only: [:create, :update]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      comment_notification @comment.post, @comment
      flash[:success] = "Comment created!"
      redirect_to root_url(anchor: "post-#{@comment.post.id}")
    else
      flash[:danger]  = "Error creating comment."
      redirect_to root_url
    end

  end

  def destroy
    @comment = Comment.find_by_id(comment_params)
    if @comment.destroy
      flash[:success] = "Comment created!"
    else
      flash[:danger]  = "Error creating comment."
    end
    redirect_to root_url(anchor: "post-#{@comment.post.id}")
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def comment_notification(post, comment)
    return if post.user.id == current_user.id
    Notification.create(user_id: post.user.id,
                        notified_by_id: current_user.id,
                        post_id: post.id,
                        notice_type: 'comment')
  end

  def mention_notifications
    if @comment.mentionees.present?
      @comment.mentionees.each do |m|
        return if m.mentionee_id == current_user.id
        Notification.create(user_id: m.mentionee_id,
                            notified_by_id: current_user.id,
                            post_id: @comment.post.id,
                            notice_type: 'comment_mention')
      end
    end
  end
end
