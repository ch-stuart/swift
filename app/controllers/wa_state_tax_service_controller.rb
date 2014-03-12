class WaStateTaxServiceController < ApplicationController

  before_filter :authenticate_admin, :except => [ :rate ]

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

    http = HTTPClient.new
    response = http.get APP_CONFIG[:wa_state_tax_url], params

    logger.info response.inspect

    hash = Hash.from_xml(response.body)

    rate = hash['response']['rate'][0]

    render :json => { rate: rate }.to_json
  end

end
