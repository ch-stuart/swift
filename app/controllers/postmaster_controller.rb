class PostmasterController < ApplicationController

  before_filter :verify_is_admin, except: [ :validate, :rates, :fit ]

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

    begin
      response = Postmaster::AddressValidation.validate params
      logger.info "Postmaster::AddressValidation.validate #{response}"

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

    rescue Exception => e
      logger.info e
      render json: e, status: :bad_request
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

    begin
      response = Postmaster::Rates.get params
      logger.info "Postmaster::Rates.get #{response}"

      respond_to do |format|
        format.html  { render :text => response }
        format.json  { render :json => response }
      end
    rescue Exception => e
      render json: e, status: :bad_request
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
  # def fit
  #   params.delete :controller
  #   params.delete :action
  #
  #   # Disabling this as it might improve speed,
  #   # and we don't require it
  #   params[:generating_img] = false;
  #
  #   boxes = Postmaster::Package.all
  #   logger.info "[Postmaster::Package.all] response: #{boxes}"
  #   logger.info "[Postmaster::Package.fit] request params: #{params.inspect}"
  #   response = Postmaster::Package.fit params
  #   logger.info "[Postmaster::Package.fit] response: #{response.inspect}"
  #
  #   render json: response
  # end

  def edit_shipment
    @sale = Sale.find params[:id]
    @boxes = Postmaster::Package.all({ limit: 66 })
  end

  # Create a shipment
  def create_shipment
    @sale = Sale.find params[:id]
    shipment_params = params[:shipment]

    postmaster_params = {
      to: {
        contact: shipment_params[:contact],
        company: shipment_params[:company],
        line1: shipment_params[:line1],
        city: shipment_params[:city],
        state: shipment_params[:state],
        zip_code: shipment_params[:zip_code],
        country: shipment_params[:country],
        phone_no: shipment_params[:phone_no]
      },
      carrier: shipment_params[:shipping_provider],
      service: shipment_params[:shipping_service],
      package: {
        weight: shipment_params[:weight],
        width: shipment_params[:width],
        height: shipment_params[:height],
        length: shipment_params[:length]
      }
    }

    # Add customs data if we're shipping INTL
    if @sale.country != "US"
      postmaster_params[:package][:customs] = {
        type: shipment_params[:customs][:type],
        comments: shipment_params[:customs][:comments],
        invoice_number: shipment_params[:customs][:invoice_number],
        contents: []
      }

      shipment_params[:contents].each do |content|
        postmaster_params[:package][:customs][:contents].push({
          description: content[:description],
          country_of_origin: content[:country_of_origin],
          quantity: content[:quantity],
          value: content[:value],
          weight: content[:weight],
          weight_units: content[:weight_units],
          hs_tariff_number: content[:hs_tariff_number]
        })
      end
    end

    if shipment_params[:envelope].present?
      logger.info "Deleting width, height and length b/c we have an envelope"
      postmaster_params[:package].delete(:width)
      postmaster_params[:package].delete(:height)
      postmaster_params[:package].delete(:length)
      postmaster_params[:package][:type] = shipment_params[:envelope]
    end

    logger.info "=> Creating shipment for: #{postmaster_params.inspect}"

    begin
      @response = Postmaster::Shipment.create postmaster_params

      logger.info "=> Postmaster::Shipment.create response: #{@response.inspect}"

      new_shipment_params = {
        postmaster_id: @response[:id],
        cost: @response[:cost],
        tracking_number: @response[:tracking].first,
        carrier: shipment_params[:shipping_provider],
        weight: shipment_params[:weight],
        width: shipment_params[:width],
        height: shipment_params[:height],
        length: shipment_params[:length],
        envelope: shipment_params[:envelope],
        sale_id: @sale.id
      }

      @shipment = Shipment.new new_shipment_params

      @sale.update_attributes({ status: "Shipped" })

      if @shipment.save
        SalesMailer.shipped(@sale, @shipment).deliver
        redirect_to(@sale, notice: 'Shipment was successfully created.')
      else
        render text: @shipment.save!
      end
    rescue Exception => e
      ExceptionNotifier.notify_exception(
        e,
        :env => request.env,
        :data => {:message => "Creating a shipment failed"}
      )
      render text: e
    end

  end

  # Create a box
  def create_box
    logger.info "=> WxHxL: #{params[:w]}x#{params[:h]}x#{params[:l]}"

    begin
      @response = Postmaster::Package.create(
          width: params[:w],
          height: params[:h],
          length: params[:l],
          name: "#{params[:w]}x#{params[:h]}x#{params[:l]}"
      )
      redirect_to postmaster_boxes_path, :notice => "Box was successfully created"
    rescue Exception => e
      ExceptionNotifier.notify_exception(
        e,
        :env => request.env,
        :data => {:message => "Creating a box failed"}
      )
    end
  end

  # List available boxes
  def boxes
    begin
      @response = Postmaster::Package.all({ limit: 66 })
      logger.info "=> BOXES: #{@response}"
    rescue Exception => e
      ExceptionNotifier.notify_exception(
        e,
        :env => request.env,
        :data => {:message => "Listing boxes failed"}
      )
      @error = e
    end
  end

end
