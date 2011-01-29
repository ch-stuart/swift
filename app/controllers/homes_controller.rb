class HomesController < ApplicationController

  before_filter :authenticate, :except => [ :index ]

  def index
    @pages = Page.all
    @products = Product.all
    @company = Company.first
  end

end