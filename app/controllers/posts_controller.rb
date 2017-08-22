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
      flash[:danger] = "Error creating post. If you're trying to post a picture,
                        please make sure the link ends in a valid format."
    end
    redirect_to request.referrer
  end

  def index
    @comment = current_user.comments.build
    @post = current_user.posts.build
    #@posts = Post.all.order(created_at: :desc)
    @posts = Post.where(user_id: post_user_ids).paginate(:page => params[:page]).
      order(created_at: :desc)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to root_url
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || root_url
  end

  private

  def post_params
    params.require(:post).permit(:content, :photo_url)
  end

  def correct_user
    if current_user.is_admin?
      @post = Post.find_by_id(params[:id])
    else
      @post = current_user.posts.find_by(id: params[:id])
    end
    if @post.nil?
      flash[:danger] = "Not authorized"
      redirect_to request.referrer
    end
  end

  def post_user_ids
    ids = []
    current_user.friends.each do |f|
      ids << f.id
    end
    ids << current_user.id
  end

end
