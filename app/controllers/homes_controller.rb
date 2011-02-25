class HomesController < ApplicationController

  before_filter :authenticate, :except => [ :index, :accessories ]

  caches_page :index, :accessories

  def index
    @pages = Page.find_all_by_status('Public')
    @featured_page = Page.find_by_featured('Featured')
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @accessories = Product.where(:status => 'Public', :kind => 'Accessory')
    @company = Company.first

    expires_in 12.hours, :public => true
  end

  def accessories
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @accessories = Product.where(:status => 'Public', :kind => 'Accessory')
    @company = Company.first

    expires_in 12.hours, :public => true
  end

end