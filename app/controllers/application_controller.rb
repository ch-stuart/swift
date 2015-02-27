class ApplicationController < ActionController::Base

  include CacheableFlash
  protect_from_forgery
  layout :resolve_layout
  before_filter :title
  helper_method :title

  protected

  def render_404
    raise ActionController::RoutingError.new("Not Found")
  end

  def title
    @title = Company.first.title
  end

  def verify_is_admin
    if current_user.try(:admin?)
      return
    else
      redirect_to root_url
    end
  end

  def resolve_layout
    if %{sessions registrations unlocks passwords confirmations}.include? controller_name
      "devise"
    else
      case action_name
      when "new", "edit", "create", "update", "destroy"
        "hub"
      else
        "application"
      end
    end
  end

  def get_user_type
    return 'ADMIN'              if current_user.try(:admin?)
    return 'WHOLESALE'          if current_user.try(:wholesale?)
    return 'USER_SIGNED_IN'     if user_signed_in?
    return 'USER_NOT_SIGNED_IN'
  end
end
