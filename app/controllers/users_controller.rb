class UsersController < Devise::RegistrationsController
  before_filter :find_user
  
  def show
  end

  def follow
    if current_user.follow?(@user)
      current_user.unfollow!(@user)
    else
      current_user.follow!(@user)
    end
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.json { head :no_content }
    end
  end

  private
    def find_user
      @user = User.find(params[:id])
    end
end