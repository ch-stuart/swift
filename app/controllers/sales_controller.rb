class SalesController < ApplicationController

  before_filter :authenticate_admin, :except => [ :checkout, :create, :success ]

  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sales }
    end
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
    @sale = Sale.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sale }
    end
  end

  # GET /sales/1234/success
  # GET /sales/1234/success.json
  def success
    @sale = Sale.find_by_guid(params[:id])

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
      charge = Stripe::Charge.create(
        amount:      params[:price],
        currency:    "usd",
        card:        params[:stripeToken],
        description: "#{params[:email]} purchasing #{params[:description]}"
      )
      @sale = Sale.create!(
        email:       params[:email],
        description: params[:description]
      )
      redirect_to order_url(guid: @sale.guid)
    rescue Stripe::CardError => e
      # The card has been declined or
      # some other error has occured
      @error = e
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
