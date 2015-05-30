class UsersController < ApplicationController

  before_filter :verify_is_admin, except: [:profile, :campout_locations, :camper_profile, :camper_profiles]
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
    start = Time.now

    response = []

    # This cache is cleared in User.rb
    json = Rails.cache.fetch "users_campout_locations" do
      campers_2015 = User
        .where(is_attending_campout_in_2015: true)
        .where.not(latitude: nil)
        .where.not(longitude: nil)
        .where.not(city: nil)

      campers_2015.each do |user|
        data = {}

        data[:latitude] = user.latitude
        data[:longitude] = user.longitude
        data[:city] = user.city
        data[:guid] = user.guid
        data[:neighbors] = campers_2015.near(user, 10).size - 1

        # not all campers have a camper association
        if user.camper.present?
          data[:public_profile] = user.camper.is_public?
          if user.camper.is_public?
            data[:public_contact] = user.contact
          end
        end

        response.push data
      end

      json = response.to_json
    end
    Rails.logger.info "UsersController#campout_locations: #{Time.now - start}s"
    render json: json
  end

  def camper_profile
    if current_user.blank? || current_user.camper.blank?
      return render text: "User not signed in or is not a camper", status: :unauthorized
    end

    if current_user.camper.is_public?
      return render text: "", status: 204
    end

    render json: current_user,
      only: [:city, :contact],
      include: {
        camper: {
          only: [
            :is_first_bike_overnight,
            :campout_location_and_miles,
            :favorite_gear,
            :why_do_you_love_bike_camping,
            :is_group_camping,
            :which_bike,
            :favorite_camp_meal,
            :hear_about
          ]
        }
      }

  end

  def camper_profiles
    campers = User.where(is_attending_campout_in_2015: true)
    public_campers = campers.joins(:camper).where(campers: { is_public: true })

    render json: public_campers,
      only: [:city, :contact, :guid],
      include: {
        camper: {
          only: [
            :is_first_bike_overnight,
            :campout_location_and_miles,
            :favorite_gear,
            :why_do_you_love_bike_camping,
            :is_group_camping,
            :which_bike,
            :favorite_camp_meal,
            :hear_about
          ]
        }
      }
  end

  def profile
    @user = current_user
    render layout: "devise"
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
          format.html { redirect_to users_url, :notice => "User was successfully updated." }
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
