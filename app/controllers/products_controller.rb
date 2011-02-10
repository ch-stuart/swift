class ProductsController < ApplicationController

  before_filter :authenticate, :except => [ :show ]
  caches_page :index, :show
  cache_sweeper :product_sweeper

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    @photos = Product.get_photos_for_tag @product

    unless logged_in?
      unless @product.public?
        # TODO: this should point to a proper 404 and allow the user to get
        #       to somewhere useful.
        return render :text => "404" 
      end
    end
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
