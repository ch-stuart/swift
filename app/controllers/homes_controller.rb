class HomesController < ApplicationController

  before_filter :authenticate, :except => [ :index ]

  def index
    @pages = Page.all
    @products = Product.all
    @company = Company.find_by_id('1')
  end

end