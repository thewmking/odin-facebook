class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :destroy

  def new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
    else
      flash[:danger] = "Error creating post."
    end
    redirect_to request.referrer
  end

  def index
    @post = current_user.posts.build
    @posts = Post.all
  end

  def update
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || root_url
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    flash[:danger] = "Not authorized"
    redirect_to request.referrer if @post.nil?
  end

end
