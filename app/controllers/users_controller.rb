class UsersController < ApplicationController

  before_filter :verify_is_admin, except: [:profile, :campout_locations, :camper_profile]
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

  def camper_profile
    if current_user.blank? || current_user.camper.blank?
      return render text: "", status: :unauthorized
    end

    if current_user.camper.public?
      return render text: "", status: 204
    end

    response = {}

    c = current_user.camper

    qa = []
    qa.push({
      q: "Is this your first bike-overnight?",
      a: c.is_first_bike_overnight
    })
    qa.push({
      q: "Where are you heading on your Swift Campout, and how far is it to your destination?",
      a: c.campout_location_and_miles
    })
    qa.push({
      q: "Tell us about your favorite piece of gear",
      a: c.favorite_gear
    })
    qa.push({
      q: "Why do you love camping by bicycle?",
      a: c.why_do_you_love_bike_camping
    })
    qa.push({
      q: "Are you heading out with a posse? What's your crew's name?",
      a: c.is_group_camping
    })
    qa.push({
      q: "What kind of bike are you riding?",
      a: c.which_bike
    })
    qa.push({
      q: "What's your go-to camp meal?",
      a: c.favorite_camp_meal
    })
    qa.push({
      q: "How did you hear about Swift Campout?",
      a: c.hear_about
    })

    response[:qa] = qa
    response[:userid] = current_user.id
    response[:public] = current_user.camper.public?

    render json: response
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
        :wholesale,
        :public
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
        :contact,
        :public
      )
    end
  end
end
