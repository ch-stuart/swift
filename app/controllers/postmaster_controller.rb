class PostmasterController < ApplicationController

  before_filter :authenticate_admin, :except => [ :validate, :rates ]

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

    respond_to do |format|
      format.html { render :text => response }
      format.xml  { render :json => response }
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

    response = Postmaster::Rates.get params

    respond_to do |format|
      format.html { render :text => response }
      format.xml  { render :json => response }
    end
  end

end
