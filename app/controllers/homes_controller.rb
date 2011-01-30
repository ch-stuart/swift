class HomesController < ApplicationController

  before_filter :authenticate, :except => [ :index ]

  caches_page :index

  def index
    @pages = Page.all
    @products = Product.all
    @company = Company.first
  end

end