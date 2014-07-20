class HubController < ApplicationController

  before_filter :verify_is_admin
  layout "hub"

  def index
    @products = Product.all
    @pages = Page.all
    @colors = Color.all
    @company = Company.first
    @categories = Category.all
  end

  def expire_home
      begin
        expire_action :controller => 'homes', :action => 'index', :user_type => 'WHOLESALE'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'ADMIN'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'USER_SIGNED_IN'
        expire_action :controller => 'homes', :action => 'index', :user_type => 'USER_NOT_SIGNED_IN'
        expire_fragment 'homes_index'
        render :text => "cache cleared"
      rescue => e
        render :text => "cache NOT cleared"
      end
  end

  # Clear everything. Flickr is cached, so
  # if something updates over there we don't
  # know. Martina has to clear it manually.
  def expire_flickr
    begin
      Rails.cache.clear
      render :text => "cache cleared!"
    rescue => e
      render :text => "cache NOT cleared. :("
    end
  end

end
