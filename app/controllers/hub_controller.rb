class HubController < ApplicationController

  before_filter :authenticate_admin
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
        expire_action :controller => "homes", :action => "index"
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