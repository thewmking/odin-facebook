class LikesController < ApplicationController
  before_action :authenticate_user!
  def create
    @like = current_user.likes.build(post_id: params[:post_id])
    @like.save
    redirect_to root_url(anchor: "post-#{@like.post.id}")
    Notification.create(user_id: @like.post.user.id,
                        notified_by_id: current_user.id,
                        post_id: @like.post.id,
                        notice_type: 'like')
  end

  def destroy
    @like = current_user.likes.where(post_id: params[:id]).first
    @like.destroy
    redirect_to root_url(anchor: "post-#{@like.post.id}")
  end
end
