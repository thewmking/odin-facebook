class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
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
end
