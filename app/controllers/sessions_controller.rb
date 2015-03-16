class SessionsController < Devise::SessionsController

  before_filter :check_user_type, only: [:new]

  protected

  def check_user_type
    @is_attending_campout_in_2015 = true if request.fullpath.include?("swiftcampout")
    @is_wholesale = true if request.fullpath.include?("wholesale")
  end

end
