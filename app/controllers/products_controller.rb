class ProductsController < ApplicationController

  before_filter :verify_is_admin, :except => [ :show, :order ]
  cache_sweeper :application_sweeper
  caches_action :show, :order, :cache_path => Proc.new { |c|
    { 'user_type' => get_user_type }
  }

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

    if @product.related_products.present?
      @product.related_products = JSON.parse @product.related_products
    end

    @related_products = load_related_products @product
    @photos = Product.get_photos_by_tag @product.flickr_tag
    @subtitle = @product.title

    respond_to do |format|
      format.html
      format.json do
        product_attrs = [
                          :id, :title, :price, :wholesale_price,
                          :humane_price, :wholesale_humane_price,
                          :question, :answer, :width, :height,
                          :length, :weight, :package_type, :kind,
                          :domestic_flat_rate_shipping_charge,
                          :international_flat_rate_shipping_charge
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
    @photos = Product.get_photos_by_tag @product.flickr_tag
    @subtitle = @product.title

    render_404 unless @product.public?
  end

  def new
    @product = Product.new

    @public_products = Product.where(status: "Public")
    @private_products = Product.where(status: "Private")
  end

  def edit
    @product = Product.find(params[:id])

    if @product.related_products.present?
      @product.related_products = JSON.parse @product.related_products
    end

    @related_products = load_related_products @product
    @public_products = Product.where('id != ?', params[:id]).where(status: "Public")
    @private_products = Product.where('id != ?', params[:id]).where(status: "Private")
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to(@product, :notice => 'Product was successfully created.')
    else
      @public_products = Product.where(status: "Public")
      @private_products = Product.where(status: "Private")

      render :action => "new"
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.related_products.present?
      @product.related_products = JSON.parse @product.related_products
    end

    @related_products = load_related_products @product
    @public_products = Product.where('id != ?', params[:id]).where(status: "Public")
    @private_products = Product.where('id != ?', params[:id]).where(status: "Private")

    if @product.update_attributes(product_params)
      redirect_to(@product, :notice => 'Product was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to(products_url)
  end

  private

  def load_related_products product
    related_products = []

    if product.related_products.present?
      logger.info "=> load_related_products for #{product.related_products.to_s}"

      JSON.parse(product.related_products).each do |id|
        # Need to check if product exists first since we don't actually
        # remove items from this array if a product is deleted
        # from active record
        if Product.exists? id
          related_product = Product.find(id)

          logger.info "=> load_related_products found #{related_product.title}"

          # Do not include private products
          if related_product.status == "Public"
            related_products.push(Product.find(id))
          end
        else
          logger.warn "=> load_related_products: product with id #{id} does not exist."
        end
      end
    end

    related_products
  end

  def product_params

    params
      .require(:product)
      .permit(
        :id,
        :title,
        :description,
        :flickr_tag,
        :specs,
        :status,
        :price,
        :kind,
        :short_title,
        :humane_price,
        :flickr_photo,
        :question,
        :answer,
        :not_for_sale,
        :not_for_sale_message,
        :category_id,
        :featured_on_homepage,
        :flickr_set,
        :short_description,
        :wholesale_humane_price,
        :wholesale_price,
        :width,
        :height,
        :length,
        :weight,
        :package_type,
        :related_products,
        :domestic_flat_rate_shipping_charge,
        :international_flat_rate_shipping_charge,
        :inventory_count,
        :related_products => [],
        :sizes_attributes => [ :title, :price, :wholesale_price, :inventory_count, :id, "_destroy" ],
        :parts_attributes => [
          :title, :price, :wholesale_price, :id, "_destroy",
          :color_ids => []
        ],
        :testimonials_attributes => [ :body, :author, :id, "_destroy" ]
      )
  end

end
