class SalesController < ApplicationController

  before_filter :authenticate_admin, :except => [ :checkout, :create, :success, :cart ]

  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.all.reverse

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
    @sales = Sale.all

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

    @description = JSON.parse(@sale.description)

    @company = Company.first
    @categories = Category.all
    @products = Product.where(:status => 'Public', :kind => 'Product')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sale }
    end
  end

  def checkout
    @sale = Sale.new

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

  # POST /sales
  # POST /sales.json
  def create
    begin
      sale_params = params[:sale]

      product_charge  = sale_params[:p]
      shipping_charge = sale_params[:shipping_charge]
      tax_amount      = sale_params[:ta]
      total           = sale_params[:t]

      # Create the charge
      stripe_charge = Stripe::Charge.create(
        amount:      total,
        currency:    "usd",
        card:        params[:stripeToken],
        description: "#{sale_params[:email]} purchasing #{sale_params[:j]}"
      )

      # Create the sale
      @sale = Sale.create!(
        email:       sale_params[:email],
        description: sale_params[:j],
        amount:      product_charge,
        total:       total,
        tax_rate:    sale_params[:tr],
        tax_amount:  sale_params[:ta],
        line1:       sale_params[:line1],
        # line2:       sale_params[:line2],
        city:        sale_params[:city],
        state:       sale_params[:state],
        zip_code:    sale_params[:zip_code],
        country:     sale_params[:country],
        pickup:      sale_params[:pickup],
        shipping_provider:  sale_params[:shipping_provider],
        shipping_charge:  shipping_charge,
        shipping_service: sale_params[:shipping_service],
        stripe_id: stripe_charge[:id]
      )

      # Create the contact if they sign up for spam
      if params[:send_me_marketing_emails]
        Contact.create(email: sale_params[:email])
      end

      # Send an email
      SalesMailer.success(sale_params[:email], @sale.guid).deliver

      redirect_to order_url(guid: @sale.guid)
    rescue Stripe::CardError => e
      # The card has been declined or
      # some other error has occured
      @error = e
      logger.warn @error.inspect
      render :checkout
    end

    # respond_to do |format|
    #   if @sale.save
    #     format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
    #     format.json { render json: @sale, status: :created, location: @sale }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @sale.errors, status: :unprocessable_entity }
    #   end
    # end
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
