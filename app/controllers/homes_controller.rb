class HomesController < ApplicationController

  before_filter :authenticate, :except => [ :index, :accessories ]

  caches_page :index

  def index
    @pages = Page.find_all_by_status('Public')
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @company = Company.first
  end
  
  def accessories
    @accessories = Product.where(:status => 'Public', :kind => 'Accessory')
    @company = Company.first
  end

end