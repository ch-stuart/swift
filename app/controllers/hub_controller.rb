class HubController < ApplicationController

  before_filter :authenticate
  caches_page :index

  def index
    @products = Product.all
    @pages = Page.all
    @colors = Color.all
    @company = Company.first
  end

end