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
        expire_page :controller => "homes", :action => "index"
        render :text => "page cache cleared"
      rescue => e
        render :text => "page cache NOT cleared"
        y e
      end
  end
end