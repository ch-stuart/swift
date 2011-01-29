class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate, :except => [ :logout ]
  before_filter :title

  helper_method :logged_in?
  helper_method :title

  def title
    @title = Company.first.title
  end

  def logged_in?
    session[:login]
  end

  def logout
    do_logout
    render :text => "Quit your browser to logout."
  end

  private

  def authenticate
    login = authenticate_or_request_with_http_basic do |username, password|
      username == APP_CONFIG['user'] && password == APP_CONFIG['pass']
    end
    session[:login] = login
  end

  def do_logout
    session[:login] = nil
  end

end
