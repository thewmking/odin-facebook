class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :destroy
  after_action  :mention_notifications, only: [:create, :update]

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
    @posts = Post.where(user_id: post_user_ids).paginate(:page => params[:page]).
      order(created_at: :desc)
    @photo_posts = Post.where(user_id: post_user_ids).where.not(photo_url: nil).
      limit(21).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = current_user.comments.build
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

  def mention_notifications
    if @post.mentionees.present?
      @post.mentionees.each do |m|
        return if m.mentionee_id == current_user.id
        Notification.create(user_id: m.mentionee_id,
                            notified_by_id: current_user.id,
                            post_id: @post.id,
                            notice_type: 'post_mention')
      end
    end
  end
end
