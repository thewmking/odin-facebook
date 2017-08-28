class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    if @user
      @posts = @user.posts.order(created_at: :desc)
    end
    if @posts
      @comment = current_user.comments.build
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to request.referrer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {}).permit(:username, :email, :password, :password_confirmation, :avatar)
    end
end
