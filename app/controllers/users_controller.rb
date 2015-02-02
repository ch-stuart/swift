class UsersController < ApplicationController

  before_filter :verify_is_admin, except: [:my_info, :edit_my_info, :update]
  before_filter :verify_is_signed_in, only: [:my_info, :edit_my_info, :update]
  layout "hub", except: [:my_info, :edit_my_info]

  def index
    @dealers = User.where(wholesale: true)
    @admins = User.where(admin: true)
    @users = User.where(admin: false, wholesale: false)
  end

  def edit
    @user = User.find params[:id]
  end

  def my_info
    @user = current_user
  end

  def edit_my_info
    @user = current_user
  end

  def update
    # Check who is updating the form
    if current_user.admin?
      @user = User.find params[:id]
    else
      @user = current_user
      logger.info "Whitelisting inputs for dealer"
    end

    respond_to do |format|
      if @user.update_attributes(user_params)
        if current_user.try(:admin?)
          format.html { redirect_to users_url, :notice => 'User was successfully updated.' }
        else
          format.html { redirect_to my_info_path, :notice => '"My Info" was successfully updated.' }
        end
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  private

  def verify_is_signed_in
    return if user_signed_in?

    render :text => "403: Forbidden", :status => 403
  end

  def user_params
    if current_user.admin?
      params.require(:user).permit(:wholesale)
    else
      params.require(:user).permit(
        :line1,
        :city,
        :state,
        :zip_code,
        :country,
        :phone_no,
        :company,
        :company_url,
        :contact
      )
    end
  end
end
