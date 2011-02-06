class HubController < ApplicationController

  before_filter :authenticate
  caches_page :index

  def index
    @products = Product.all
    @pages = Page.all
    @company = Company.first
  end

end