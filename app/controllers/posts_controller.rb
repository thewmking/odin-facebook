class PostsController < ApplicationController

  def new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
    else
      flash[:danger] = "Error creating post."
    end
    redirect_to root_url
  end

  def index
    @post = current_user.posts.build
    @posts = Post.all
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

end
