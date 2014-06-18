class ApplicationController < ActionController::Base

  include CacheableFlash

  protect_from_forgery

  layout :resolve_layout

  before_filter :authenticate_admin, :except => [ :logout, :wholesale_login ]
  before_filter :authenticate_wholesale, :only => [ :wholesale_login ]
  before_filter :title, :except => [ :expire_cache ]

  helper_method :title

  # heroku post deploy hook
  # does not work. can't get sweeper to work
  # can't call expire_action without there being a
  # request
  # def expire_cache
  #   ApplicationSweeper.instance.expire_cache
  #   render :text => "expired"
  # end

  def logout
    render :text => "Quit your browser to logout."
  end

  def wholesale_login
    redirect_to "/"
  end

  protected

  def render_404
    raise ActionController::RoutingError.new("Not Found")
  end

  def title
    @title = Company.first.title
  end

  def authenticate_admin
    @hub = true
    login = authenticate_or_request_with_http_basic do |username, password|
      username == APP_CONFIG[:admin_user] && password == APP_CONFIG[:admin_pass]
    end
    session[:is_admin_user] = login
  end

  def authenticate_wholesale
    login = authenticate_or_request_with_http_basic do |username, password|
      username == APP_CONFIG[:wholesale_user] && password == APP_CONFIG[:wholesale_pass]
    end
    session[:is_wholesale_user] = login
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
