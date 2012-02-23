class HubController < ApplicationController

  before_filter :authenticate
  layout "hub"

  def index
    @products = Product.all
    @pages = Page.all
    @colors = Color.all
    @company = Company.first
  end

  def expire_home
      begin
        expire_action :controller => "homes", :action => "index"
        render :text => "cache cleared"
      rescue => e
        render :text => "cache NOT cleared"
        y e
      end
  end
  
end