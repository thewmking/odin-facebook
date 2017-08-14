class LikesController < ApplicationController
  before_action :authenticate_user!
  def create
    @like = current_user.likes.build(post_id: params[:post_id])
    @like.save
    redirect_to request.referrer
  end

  def destroy
    @like = current_user.likes.where(post_id: params[:id]).first
    @like.destroy
    redirect_to request.referrer
  end
end
