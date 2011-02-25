class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate, :except => [ :logout ]
  before_filter :title

  helper_method :title

  private

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

end
