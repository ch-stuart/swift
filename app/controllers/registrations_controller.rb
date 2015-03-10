class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params

    devise_parameter_sanitizer
      .for(:sign_up) do |u|
        u.permit(
          :is_attending_campout_in_2015,
          :is_pending_dealer,
          :email,
          :password,
          :password_confirmation,
          :contact,
          :city,
          :state,
          :zip_code
        )
    end

    devise_parameter_sanitizer
      .for(:account_update) do |u|
        u.permit(
          :is_attending_campout_in_2015,
          :is_pending_dealer,
          :email,
          :password,
          :password_confirmation,
          :current_password,
          :contact,
          :city,
          :state,
          :zip_code
        )
    end

  end

end
