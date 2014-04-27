class SalesController < ApplicationController

  before_filter :authenticate_admin, :except => [ :checkout, :create, :success, :cart, :charge ]
  caches_action :cart, :checkout, :cache_path => Proc.new { |c|
      { 'user_type' => session[:is_wholesale_user] ? "WS" : "STANDARD" }
  }
  cache_sweeper ApplicationSweeper

  # GET /sales
  # GET /sales.json
  def index
    @sales_not_shipped = Sale.where(status: 'Not Shipped').reverse
    @sales_shipped = Sale.where(status: 'Shipped').reverse

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

    render :layout => "hub"

    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @sale }
    # end
  end

  # GET /sales/1234/success
  # GET /sales/1234/success.json
  def success
    @sale = Sale.find_by_guid(params[:guid])
    @shipments = @sale.shipments
    @description = JSON.parse(@sale.description)

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
      format.json { render json: @sale }
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
      render json: { error: e }.to_json, status: 500
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
      commercial:        params[:commercial],
      weight:            params[:weight],
      pickup:            params[:pickup],
      shipping_provider: params[:shipping_provider],
      shipping_charge:   params[:shipping_charge],
      shipping_service:  params[:shipping_service],
      stripe_id:         params[:stripe_id],
      status:            "Not Shipped"
    )

    if @sale.save
      # Send an email
      # TODO run this in the background or whatever
      # TODO don't want to fail order if this fails
      # but it'd be nice to know if it's happening
      begin
        SalesMailer.success(params[:email], @sale.guid).deliver
        SalesMailer.notify_swift(@sale).deliver

        # Create the contact if they sign up for spam
        if params[:send_me_marketing_emails]
          Contact.create(email: params[:email])
        end
      rescue Exception => e
        # FIXME email about this
        logger.info e
      end

      render json: { guid: @sale.guid }.to_json
    else
      render json: { error: @sale.errors }, :status => :unprocessable_entity
    end
  end

  # PUT /sales/1
  # PUT /sales/1.json
  def update
    @sale = Sale.find(params[:id])

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
end
