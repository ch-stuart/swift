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
    Rails.logger.info controller_name
    if controller_name == "sessions"
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

end
