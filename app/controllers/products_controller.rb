class ProductsController < ApplicationController

  before_filter :authenticate_admin, :except => [ :show, :order ]
  caches_action :show, :order, :cache_path => Proc.new { |c|
      { 'user_type' => session[:is_wholesale_user] ? "WS" : "STANDARD" }
  }
  cache_sweeper ApplicationSweeper

  def index
    @products = Product.all(:order => 'kind DESC')
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
        product_attrs = [:id, :title, :status, :price, :kind, :short_title, :humane_price, :question, :answer, :not_for_sale, :not_for_sale_message]
        part_attrs    = [:id, :title, :price]
        color_attrs   = [:id, :title, :price, :hex]
        size_attrs    = [:id, :title, :price]

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
