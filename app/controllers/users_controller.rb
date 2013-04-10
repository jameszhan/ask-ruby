class UsersController < Devise::RegistrationsController
  before_filter :find_user, only: [:show, :follow]
  before_filter :login_required, only: [:follow, :auth_unbind, :avatar, :crop]
  
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
  
  def avatar
   @user = current_user
  end

  def crop
   @user = current_user
   unless @user.update_attributes(params[:user])
     render action: 'avatar'
   end
   redirect_to user_path(@user)
  end

  def create
   build_resource

   if resource.save
     if resource.active_for_authentication?
       create_success
     else
       set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
       expire_session_data_after_sign_in!
       respond_with resource, :location => after_inactive_sign_up_path_for(resource)
     end
   else
     clean_up_passwords resource
     respond_with resource
   end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    
    password_required = session[:login_type].try(:to_sym) != :omniauth
    if password_required ? resource.update_with_password(resource_params) : resource.update_attributes(resource_params) 
      update_success prev_unconfirmed_email, password_required
    else
      clean_up_passwords resource
      respond_with resource
    end
  end  

  protected
    def create_success
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_up(resource_name, resource)
      if params[:user][:avatar].present?
        render action: 'avatar'
      else
        respond_with resource, :location => after_sign_up_path_for(resource)
      end
    end
     
    def update_success(prev_unconfirmed_email, by_pass)
      if is_navigational_format?
         flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
           :update_needs_confirmation : :updated
         set_flash_message :notice, flash_key
       end
       sign_in resource_name, resource, :bypass => by_pass
       if params[:user][:avatar].present?
         render action: 'avatar'
       else
         respond_with resource, :location => after_update_path_for(resource)
       end
    end
      
    def login_required
      unless current_user
        redirect_to new_user_session_path
      end
    end  
      
    def find_user
      @user = User.find(params[:id])
    end
end