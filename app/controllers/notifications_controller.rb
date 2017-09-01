class NotificationsController < ApplicationController
  def link_through
    @notification = Notification.find(params[:id])
    @notification.update read: true
    redirect_to @notification.link_path
  end

  def index
    @notifications = current_user.active_notifications.order('created_at DESC')
  end

end
