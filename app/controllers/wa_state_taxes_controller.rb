class WaStateTaxesController < ApplicationController

  # Get tax rate for a WA state address
  #
  # params:
  #
  # output
  # addr
  # city
  # zip
  def rate
    params.delete(:controller)
    params.delete(:action)

    wa_zip = WaStateZipCodes.new

    if wa_zip.is_wa_zip? params[:zip]
      http = HTTPClient.new
      response = http.get APP_CONFIG[:wa_state_tax_url], params

      logger.info response.inspect

      hash = Hash.from_xml(response.body)

      rate = hash['response']['rate'][0]

      render :json => { rate: rate }.to_json
    else
      render :json => { rate: nil }.to_json
    end
  end

end
