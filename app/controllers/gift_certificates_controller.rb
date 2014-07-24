class GiftCertificatesController < ApplicationController

  before_filter :verify_is_admin, :except => [:show]

  layout "hub"

  # GET /gift_certificates
  # GET /gift_certificates.json
  def index
    @gift_certificates = GiftCertificate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gift_certificates }
    end
  end

  # GET /gift_certificates/1
  # GET /gift_certificates/1.json
  def show
    if params[:guid].present?
      @gift_certificate = GiftCertificate.where(guid: params[:guid]).first
    elsif current_user.try(:admin)
      @gift_certificate = GiftCertificate.find(params[:id])
    else
      render_404
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gift_certificate.to_json(except: [:id, :updated_at, :sale_id]) }
    end
  end

  # GET /gift_certificates/new
  # GET /gift_certificates/new.json
  def new
    @gift_certificate = GiftCertificate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gift_certificate }
    end
  end

  # GET /gift_certificates/1/edit
  def edit
    @gift_certificate = GiftCertificate.find(params[:id])
  end

  # POST /gift_certificates
  # POST /gift_certificates.json
  def create
    @gift_certificate = GiftCertificate.new(params[:gift_certificate])

    respond_to do |format|
      if @gift_certificate.save
        format.html { redirect_to @gift_certificate, notice: 'Gift certificate was successfully created.' }
        format.json { render json: @gift_certificate, status: :created, location: @gift_certificate }
      else
        format.html { render action: "new" }
        format.json { render json: @gift_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gift_certificates/1
  # PUT /gift_certificates/1.json
  def update
    @gift_certificate = GiftCertificate.find(params[:id])

    respond_to do |format|
      if @gift_certificate.update_attributes(params[:gift_certificate])
        format.html { redirect_to @gift_certificate, notice: 'Gift certificate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gift_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gift_certificates/1
  # DELETE /gift_certificates/1.json
  def destroy
    @gift_certificate = GiftCertificate.find(params[:id])
    @gift_certificate.destroy

    respond_to do |format|
      format.html { redirect_to gift_certificates_url }
      format.json { head :no_content }
    end
  end
end
