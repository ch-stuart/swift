class HubController < ApplicationController
  
  def index
    @products = Product.all
    @pages = Page.all
    @companies = Company.all
  end

end