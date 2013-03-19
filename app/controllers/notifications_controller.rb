class NotificationsController < ApplicationController

  def index
    if current_user
      @notifications = current_user.notifications
      current_user.read_notifications(@notifications)
    
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @notifications }
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
    end
  end
end
