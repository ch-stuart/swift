class HubController < ApplicationController

  before_filter :authenticate

  def index
    @products = Product.all
    @pages = Page.all
    @colors = Color.all
    @company = Company.first
  end

end