class PreApprovedDealersController < ApplicationController

  before_filter :verify_is_admin

  layout "hub"

  # GET /pre_approved_dealers
  # GET /pre_approved_dealers.json
  def index
    @pre_approved_dealers = PreApprovedDealer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pre_approved_dealers }
    end
  end

  # GET /pre_approved_dealers/1
  # GET /pre_approved_dealers/1.json
  def show
    @pre_approved_dealer = PreApprovedDealer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pre_approved_dealer }
    end
  end

  # GET /pre_approved_dealers/new
  # GET /pre_approved_dealers/new.json
  def new
    @pre_approved_dealer = PreApprovedDealer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pre_approved_dealer }
    end
  end

  # GET /pre_approved_dealers/1/edit
  def edit
    @pre_approved_dealer = PreApprovedDealer.find(params[:id])
  end

  # POST /pre_approved_dealers
  # POST /pre_approved_dealers.json
  def create
    @pre_approved_dealer = PreApprovedDealer.new(params[:pre_approved_dealer])

    respond_to do |format|
      if @pre_approved_dealer.save
        format.html { redirect_to @pre_approved_dealer, notice: 'Pre approved dealer was successfully created.' }
        format.json { render json: @pre_approved_dealer, status: :created, location: @pre_approved_dealer }
      else
        format.html { render action: "new" }
        format.json { render json: @pre_approved_dealer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pre_approved_dealers/1
  # PUT /pre_approved_dealers/1.json
  def update
    @pre_approved_dealer = PreApprovedDealer.find(params[:id])

    respond_to do |format|
      if @pre_approved_dealer.update_attributes(params[:pre_approved_dealer])
        format.html { redirect_to @pre_approved_dealer, notice: 'Pre approved dealer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pre_approved_dealer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pre_approved_dealers/1
  # DELETE /pre_approved_dealers/1.json
  def destroy
    @pre_approved_dealer = PreApprovedDealer.find(params[:id])
    @pre_approved_dealer.destroy

    respond_to do |format|
      format.html { redirect_to pre_approved_dealers_url }
      format.json { head :no_content }
    end
  end
end
