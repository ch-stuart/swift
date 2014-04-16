class PostmasterController < ApplicationController

  before_filter :authenticate_admin, :except => [ :validate, :rates, :fit ]

  layout "hub"

  # Validate and normalize an address. The address will be
  # normalized/corrected if possible. An approximate geocoded
  # location will also be returned.
  #
  # params:
  #
  # line1
  # line2
  # line3
  # city
  # state
  # zip_code
  # country (optional)
  def validate
    params.delete(:controller)
    params.delete(:action)

    response = Postmaster::AddressValidation.validate params

    # The response from Postmaster is shitty (does not follow docs)
    # Walk the array and figure out if this is a commercial address
    response.addresses[0].each do |thing|
        if thing[0] == :commercial && thing[1] == true
            response.commercial = true
        end
    end

    respond_to do |format|
      format.html  { render :text => response }
      format.json  { render :json => response }
    end
  end

  # Ask for the cost to ship a package between
  # two zip codes.
  #
  # params
  #
  # from_zip
  # to_zip
  # weight
  # etc.
  def rates
    params.delete(:controller)
    params.delete(:action)

    logger.info "params for rates: #{params}"

    response = Postmaster::Rates.get params

    respond_to do |format|
      format.html  { render :text => response }
      format.json  { render :json => response }
    end
  end

  # Fit packages in the best box
  #
  # params
  #
  # This endpoint sucks. It will either
  # succeed pretty quickly, or it will
  # take 60s and timeout and return a
  # worthless response
  def fit
    params.delete :controller
    params.delete :action

    # Disabling this as it might improve speed,
    # and we don't require it
    params[:generating_img] = false;

    boxes = Postmaster::Package.all
    logger.info "[Postmaster::Package.all] response: #{boxes}"
    logger.info "[Postmaster::Package.fit] request params: #{params.inspect}"
    response = Postmaster::Package.fit params
    logger.info "[Postmaster::Package.fit] response: #{response.inspect}"

    render json: response
  end

  # Create a shipment
  def create_shipment
    @sale = Sale.find params[:id]

    shipping_params = {
      to: {
        contact: @sale.contact,
        company: @sale.company,
        line1: @sale.line1,
        city: @sale.city,
        state: @sale.state,
        zip_code: @sale.zip_code,
        phone_no: @sale.phone_no
      },
      carrier: @sale.shipping_provider,
      service: @sale.shipping_service,
      package: {
        weight: @sale.weight,
        # FIXME send the correct WxHxL
        width: 6,
        height: 8,
        length: 10
      }
    }

    logger.info "=> Creating shipment for: #{shipping_params.inspect}"

    begin
      @response = Postmaster::Shipment.create shipping_params

      logger.info "=> SHIPMENT: #{@response.inspect}"

      sale_params = {}
      sale_params[:status] = "Shipped"
      sale_params[:postmaster_id] = @response[:id]
      sale_params[:shipping_tracking_number] = @response[:tracking].first

      if @sale.update_attributes sale_params
        SalesMailer.shipped(@sale).deliver
        redirect_to(@sale, :notice => 'Shipment was successfully created.')
      else
        render text: "Updating the sale failed. Contact cs@enure.net."
      end
    rescue Exception => e
      render text: e
    end

  end

  # Create a box
  def create_box
    logger.info "=> WxHxL: #{params[:w]}x#{params[:h]}x#{params[:l]}"
    @response = Postmaster::Package.create(
        width: params[:w],
        height: params[:h],
        length: params[:l],
        name: "#{params[:w]}x#{params[:h]}x#{params[:l]}"
    )
    redirect_to postmaster_boxes_path, :notice => "Box was successfully created"
  end

  # List available boxes
  def boxes
    begin
      @response = Postmaster::Package.all
      logger.info "=> BOXES: #{@response}"
    rescue Exception => e
      @error = e
    end
  end

end
