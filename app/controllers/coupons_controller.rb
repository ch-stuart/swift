class CouponsController < ApplicationController

  before_filter :verify_is_admin, :except => [:valid]

  layout "hub"

  # GET /coupons
  # GET /coupons.json
  def index
    @coupons = Coupon.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/1/valid
  # GET /coupons/1/valid.json
  def valid
    @coupon = Coupon.find_by_code! params[:id]

    if @coupon.is_invalid?
      render_404
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json do
        render :json => @coupon.to_json(:only => [:percent_off, :cents_off, :code])
      end
    end
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new
    @coupon = Coupon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/1/edit
  def edit
    @coupon = Coupon.find(params[:id])
  end

  # POST /coupons
  # POST /coupons.json
  def create
    @coupon = Coupon.new(coupon_params)

    respond_to do |format|
      if @coupon.save
        format.html { redirect_to @coupon, notice: 'Coupon was successfully created.' }
        format.json { render json: @coupon, status: :created, location: @coupon }
      else
        format.html { render action: "new" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /coupons/1
  # PUT /coupons/1.json
  def update
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      if @coupon.update_attributes(coupon_params)
        format.html { redirect_to @coupon, notice: 'Coupon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy

    respond_to do |format|
      format.html { redirect_to coupons_url }
      format.json { head :no_content }
    end
  end

  private

  def coupon_params
    params
      .require(:coupon)
      .permit(
        :title,
        :description,
        :published,
        "start_date(1i)",
        "start_date(2i)",
        "start_date(3i)",
        "start_date(4i)",
        "start_date(5i)",
        "end_date(1i)",
        "end_date(2i)",
        "end_date(3i)",
        "end_date(4i)",
        "end_date(5i)",
        :percent_off,
        :cents_off,
        :code
      )
  end
end
