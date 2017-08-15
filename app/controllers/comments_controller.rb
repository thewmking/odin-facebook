class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Comment created!"
    else
      flash[:danger]  = "Error creating comment."
    end
    redirect_to request.referrer
  end

  def destroy

  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
