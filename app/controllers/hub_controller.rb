class HubController < ApplicationController

  caches_page :index

  def index
    @products = Product.all
    @pages = Page.all
    @companies = Company.all
  end

end