class SalesController < ApplicationController

  before_filter :verify_is_admin, :except => [ :checkout, :create, :success, :cart, :charge, :history, :coupon ]
  # cache_sweeper ApplicationSweeper

  # GET /sales
  # GET /sales.json
  def index
    @sales_not_shipped = Sale.not_shipped
    @sales_printed = Sale.printed
    @sales_shipped = Sale.shipped
    @sales_deleted = Sale.deleted

    render :layout => "hub"
    #
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @sales }
    # end
  end

  # GET /sales
  # GET /sales.json
  def cart
    @company = Company.first
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sales }
    end
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
    @sale = Sale.find(params[:id])
    @shipments = @sale.shipments

    if @sale.coupon_code.present?
      begin
        @coupon = Coupon.find_by_code! @sale.coupon_code
      rescue Exception => e
        logger.warn e
      end
    end

    render :layout => "hub"
  end

  # GET /sales/1234/success
  # GET /sales/1234/success.json
  def success
    @sale = Sale.find_by_guid(params[:guid])
    @shipments = @sale.shipments

    # This is bad if this happens
    if @sale.description.present?
      @description = JSON.parse(@sale.description)
    else
      @description = nil
    end

    @company = Company.first
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sale }
    end
  end

  def ready_for_pickup
    @sale = Sale.find params[:id]
    @sale.update_attributes({ status: "Shipped" })
    SalesMailer.ready_for_pickup(@sale).deliver
    redirect_to(@sale, notice: 'Email successfully sent to customer.')
  end

  def checkout
    @company = Company.first
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')

    respond_to do |format|
      format.html # new.html.erb
      # format.json { render json: @sale }
    end
  end

  def history
    @company = Company.first
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')

    if user_signed_in?
      @sales = Sale.where(email: current_user.email)
    else
      @sales = []
    end
  end

  # GET /sales/new
  # GET /sales/new.json
  def new
    @sale = Sale.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sale }
    end
  end

  # GET /sales/1/edit
  def edit
    @sale = Sale.find(params[:id])
  end

  # POST /sales/charge.json
  def charge
    begin
      # Create the charge
      stripe_charge = Stripe::Charge.create(
        amount:      params[:total].to_i,
        currency:    "usd",
        card:        params[:stripeToken],
        description: "#{params[:email]}"
      )

      render json: { id: stripe_charge.id }.to_json
    rescue Stripe::CardError => e
      # The card has been declined or
      # some other error has occured
      logger.error e.inspect

      # FIXME appears to not actually be responding with JSON. :(
      render json: { error: e }.to_json, status: :internal_server_error
    end
  end

  # POST /sales
  # POST /sales.json
  def create
    # Create the sale
    @sale = Sale.new(
      contact:           params[:contact],
      company:           params[:company],
      email:             params[:email],
      description:       params[:description],
      amount:            params[:amount],
      total:             params[:total],
      tax_rate:          params[:tax_rate],
      tax_amount:        params[:tax_amount],
      line1:             params[:line1],
      # line2:             params[:line2],
      city:              params[:city],
      state:             params[:state],
      zip_code:          params[:zip_code],
      country:           params[:country],
      phone_no:          params[:phone_no],
      commercial:        params[:commercial] || false,
      weight:            params[:weight],
      pickup:            params[:pickup] || false,
      shipping_contact:  params[:shipping_contact],
      shipping_provider: params[:shipping_provider],
      shipping_charge:   params[:shipping_charge],
      shipping_service:  params[:shipping_service],
      shipping_service_is_flat_rate:  params[:shipping_service_is_flat_rate],
      stripe_id:         params[:stripe_id],
      status:            "Not Shipped",
      gift_certificate_guid: params[:gift_certificate_guid],
      gift_cert_remain:      params[:gift_cert_remain],
      gift_cert_applied:     params[:gift_cert_applied],
      total_with_gift_cert:  params[:total_with_gift_cert],
      coupon_code:           params[:coupon_code] || false
    )

    if @sale.save
      # Send an email
      # TODO run this in the background or whatever
      # TODO don't want to fail order if this fails
      # but it'd be nice to know if it's happening
      begin
        create_gift_certificates @sale
      rescue Exception => e
        throw_exception e
      end

      begin
        update_gift_certificates @sale
      rescue Exception => e
        throw_exception e
      end

      begin
        update_inventory @sale
      rescue Exception => e
        throw_exception e
      end

      begin
        # Create the contact if they sign up for spam
        if params[:send_me_marketing_emails]
          Contact.create(email: params[:email])
        end
      rescue Exception => e
        throw_exception e
      end

      SalesMailer.success(params[:email], @sale.guid).deliver
      SalesMailer.notify_swift(@sale).deliver

      render json: { guid: @sale.guid }.to_json
    else
      render json: { error: @sale.errors }, :status => :unprocessable_entity
    end
  end

  # PUT /sales/1
  # PUT /sales/1.json
  def update
    @sale = Sale.find(params[:id])

    if params[:sale][:status] == "Shipped" && params[:sale][:email] == "true"
      SalesMailer.shipped_flat_rate(@sale).deliver
    end

    respond_to do |format|
      if @sale.update_attributes(params[:sale])
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to sales_url }
      format.json { head :no_content }
    end
  end

  protected

  def create_gift_certificates sale
    description = JSON.parse(sale.description)

    description["products"].each do |product|
      if product["kind"] == "Gift Certificate"
        price_in_cents = product["price"].to_i * 100
        gift_certificate = GiftCertificate.new(sale_id: sale.id, amount: price_in_cents)

        if gift_certificate.save
          logger.info "YAY I MADE A GIFT CERTIFICATE"
        else
          ExceptionNotifier.notify_exception(
            e,
            env: request.env,
            data: { message: "Failed to create Gift Certificate" }
          )
        end

      else
        logger.info "SalesController#create_gift_certificates: Product is not a gift certificate. #{product["kind"]}"
      end
    end
  end

  def update_gift_certificates sale
    if sale.gift_certificate_guid.present?
      gift = GiftCertificate.find_by_guid sale.gift_certificate_guid

      begin
        # logger.info "Updating Gift Certificate #{sale.gift_certificate_guid}. Subtracting #{sale.gift_cert_applied} from #{gift.remaining_amount}."
        gift.remaining_amount = gift.remaining_amount - sale.gift_cert_applied
        gift.save!
      rescue Exception => e
        ExceptionNotifier.notify_exception(
          e,
          env: request.env,
          data: { message: "Failed to update Gift Certificate" }
        )
      end
    else
      logger.info "SalesController#update_gift_certificates: Sale has no gift certificate"
    end
  end

  def update_inventory sale
    description = JSON.parse sale[:description]
    sold_products = description["products"]

    sold_products.each do |sold_product|
      if sold_product["selectedSize"].present?
        size = Size.find sold_product["selectedSize"]["id"]
      end

      product = Product.find sold_product["id"]
      product.update_inventory(sold_product["quantity"], size) unless product.nil?
    end
  end

  def throw_exception e
    logger.error e

    ExceptionNotifier.notify_exception(
      e,
      env: request.env,
      data: { message: "Post sale task failed." }
    )
  end
end
