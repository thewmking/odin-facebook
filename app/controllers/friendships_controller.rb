class FriendshipsController < ApplicationController
  before_action :check_user
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:success] = "Added friend"
    else
      flash[:danger] = "Error adding friend"
    end
      redirect_to root_url
  end

  private

    def check_user
      friend = User.where(id: params[:friend_id]).first
      if friend == current_user
        flash[:danger] = "You can't be your own friend, ya dimwit!"
        redirect_to request.referrer
      end
    end
end
