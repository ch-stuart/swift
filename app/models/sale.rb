class Sale < ActiveRecord::Base

  attr_accessible :description, :email, :guid, :amount, :weight, :line1, :line2, :city, :state, :zip_code, :country, :shipping_provider, :shipping_service, :shipping_charge, :stripe_id, :tax_rate, :tax_amount, :total, :pickup

  before_create :populate_guid

  private

  def populate_guid
    self.guid = SecureRandom.hex(4)
  end

end
