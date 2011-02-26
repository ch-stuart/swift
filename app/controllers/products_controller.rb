class ProductsController < ApplicationController

  before_filter :authenticate, :except => [ :show, :order, :colors ]
  caches_page :show, :order, :colors, :cart

  def index
    @products = Product.all
  end

  def show
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @product = Product.find(params[:id])
    @photos = Product.get_photos_for_tag @product
    @company = Company.first
  end

  def order
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @company = Company.first

    @product = Product.find(params[:id])
    @photos = Product.get_photos_for_tag @product
  end

  def colors
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @company = Company.first

    @product = Product.find(params[:id])
    @photos = Product.get_photos_for_tag @product
  end

  def cart
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @company = Company.first

    @products = Product.where(:status => 'Public', :kind => 'Product')
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    # 1.times do
    #   part = @product.parts.build
    #   # 2.times { part.colors.build }
    # end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to(@product, :notice => 'Product was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      redirect_to(@product, :notice => 'Product was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to(products_url)
  end
end
