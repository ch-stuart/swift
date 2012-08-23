class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :resolve_layout

  before_filter :authenticate, :except => [ :logout ]
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

  protected

  def title
    @title = Company.first.title
  end

  def logout
    render :text => "Quit your browser to logout."
  end

  def authenticate
    @hub = true
    login = authenticate_or_request_with_http_basic do |username, password|
      username == APP_CONFIG['user'] && password == APP_CONFIG['pass']
    end
    session[:login] = login
  end

  def resolve_layout
    case action_name
    when "new", "edit", "create", "update", "destroy"
      "hub"
    else
      "application"
    end
  end

end
