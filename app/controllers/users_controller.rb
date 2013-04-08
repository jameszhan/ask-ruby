class UsersController < Devise::RegistrationsController
  before_filter :find_user, only: [:show, :follow]
  
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
  
  def auth_unbind
    provider = params[:provider]
    if current_user.authentications.count <= 1
      redirect_to edit_user_registration_path, :flash => {:error => t("users.unbind_warning")}
    else
      current_user.authentications.destroy_all({ :provider => provider })
      redirect_to edit_user_registration_path, :flash => {:warring => t("users.unbind_success", :provider => provider.titleize)}
    end
  end
  

  private
    def find_user
      @user = User.find(params[:id])
    end
end