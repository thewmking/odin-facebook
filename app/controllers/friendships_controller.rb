class FriendshipsController < ApplicationController
  before_action :check_user

  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:success] = "Friend request sent"
      Notification.create(user_id: @friendship.friend_id,
                          notified_by_id: current_user.id,
                          notice_type: 'friend request')
    else
      flash[:danger] = "Error sending friend request"
    end
      redirect_to :back
  end

  def update
    @friendship ||= Friendship.find_by(id: params[:id])
    @friendship.update(accepted: true)
    if @friendship.save
      flash[:success] = "Successfully confirmed friend"
      Notification.create(user_id: @friendship.user_id,
                          notified_by_id: current_user.id,
                          notice_type: 'friend accept')
    else
      flash[:danger] = "Error confirming friend."
    end
    redirect_to :back
  end

  def destroy
    @friendship = Friendship.find_by(id: params[:id])
    @friendship ||= User.find_by(id: params[:id]).friendships.find_by(friend_id: current_user.id)
    @friendship ||= current_user.friendships.find_by(friend_id: params[:id])
    @friendship.destroy
    flash[:success] = "Bye Felicia"
    redirect_to :back
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
