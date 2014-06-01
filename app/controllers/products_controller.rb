class ProductsController < ApplicationController

  before_filter :authenticate_admin, :except => [ :show, :order ]
  caches_action :show, :order, :cache_path => Proc.new { |c|
      { 'user_type' => session[:is_wholesale_user] ? "WS" : "STANDARD" }
  }
  cache_sweeper ApplicationSweeper

  def index
    @public_products = Product.where(status: 'Public', kind: 'Product').order('title ASC')
    @private_products = Product.where(status: 'Private', kind: 'Product').order('title ASC')
    @public_stock = Product.where(status: 'Public', kind: 'Stock').order('title ASC')
    @private_stock = Product.where(status: 'Private', kind: 'Stock').order('title ASC')
    @public_accessories = Product.where(status: 'Public', kind: 'Accessory').order('title ASC')
    @private_accessories = Product.where(status: 'Private', kind: 'Accessory').order('title ASC')
    render :layout => "hub"
  end

  def show
    @product = Product.find(params[:id])
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @photos = Product.get_photos_by_tag @product.flickr_tag
    @company = Company.first
    @subtitle = @product.title

    respond_to do |format|
      format.html
      format.json do
        product_attrs = [
                          :id, :title, :price, :wholesale_price,
                          :humane_price, :wholesale_humane_price,
                          :question, :answer, :width, :height,
                          :length, :weight, :package_type
                        ]
        part_attrs    = [:id, :title, :price, :wholesale_price]
        color_attrs   = [:id, :title, :price, :wholesale_price, :hex]
        size_attrs    = [:id, :title, :price, :wholesale_price]

        render :json => @product.to_json(
          :only => product_attrs,
          :include => [
            {
              :parts => {
                :only => part_attrs,
                :include => {
                  :colors => {
                    :only => color_attrs
                  }
                }
              },
            },
            :sizes => {
              :only => size_attrs
            }
          ]
        )
      end
    end

    render_404 unless @product.public?
  end

  def order
    @product = Product.find(params[:id])
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')
    @company = Company.first
    @colors = Color.all
    @photos = Product.get_photos_by_tag @product.flickr_tag
    @subtitle = @product.title

    render_404 unless @product.public?
  end

  def new
    @product = Product.new
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
