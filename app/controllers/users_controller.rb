class UsersController < ApplicationController

  before_filter :verify_is_admin, except: [:profile, :campout_locations]
  before_filter :verify_is_signed_in, only: [:profile]

  layout "hub"

  def index
    @dealers = User.where(wholesale: true)
    @admins = User.where(admin: true)
    @users = User.where(admin: false, wholesale: false)
    @campers_2015 = User.where(is_attending_campout_in_2015: true)
  end

  # http://stackoverflow.com/questions/5857915
  def campout_locations
    # This cache is cleared in User.rb
    json = Rails.cache.fetch "users_campout_locations" do
      campers_2015 = User
        .where(is_attending_campout_in_2015: true)
        .where.not(latitude: nil)
        .where.not(longitude: nil)
        .where.not(city: nil)

      @campers_2015 = campers_2015

      @campers_2015 = @campers_2015.as_json

      @campers_2015.each do |camper|
        this_camper = User.find camper['id']

        size = campers_2015.near(User.find(camper['id']), 10).size - 1

        camper['neighbors'] = size
      end

      @campers_2015.to_json(only: ['latitude', 'longitude', 'city', 'neighbors'])
    end

    render json: json
  end

  def profile
    @user = current_user
    render layout: 'devise'
  end

  def show
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    # Check who is updating the form
    if current_user.admin?
      @user = User.find params[:id]
    else
      @user = current_user
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
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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

    render text: "403: Forbidden", status: 403
  end

  def user_params
    if current_user.admin?
      params.require(:user).permit(
        :line1,
        :city,
        :state,
        :zip_code,
        :country,
        :phone_no,
        :company,
        :company_url,
        :contact,
        :wholesale
      )
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
