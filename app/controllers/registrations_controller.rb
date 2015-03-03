class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:is_attending_campout_in_2015, :is_pending_dealer, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:is_attending_campout_in_2015, :is_pending_dealer, :email, :password, :password_confirmation, :current_password)}
  end

end
