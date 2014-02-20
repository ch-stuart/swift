class PostmasterController < ApplicationController

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

    response = Postmaster::AddressValidation.validate(params)

    respond_to do |format|
      format.html { render :text => response }
      format.xml  { render :json => response }
    end
  end

end
