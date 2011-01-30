class HomesController < ApplicationController

  before_filter :authenticate, :except => [ :index ]

  caches_page :index

  def index
    @pages = Page.find_all_by_status('Public')
    @products = Product.find_all_by_status('Public')
    @company = Company.first
  end

end