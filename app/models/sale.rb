class Sale < ActiveRecord::Base

  has_many :shipments

  attr_accessible :description, :email, :guid, :amount, :weight, :line1, :line2, :city, :state, :zip_code, :country, :shipping_provider, :shipping_service, :shipping_charge, :stripe_id, :tax_rate, :tax_amount, :total, :pickup, :status, :phone_no, :contact, :company, :commercial, :postmaster_id, :shipping_tracking_number

  before_create :populate_guid

  # validates_presence_of :email, :description
  # validates :email, format: /@/

  STATUSES = ["Not Shipped", "Printed", "Shipped", "Deleted"]
  attr_reader :STATUSES
  validates :status, :inclusion => { :in => STATUSES, :message => "%{value} is not a valid status" }

  validates_presence_of :email, :amount, :total, :stripe_id

  def get_shipping_price_diff
    # expected is what we charged the customer
    # actual is what we paid to ship

    if self.shipping_charge && self.shipments.present?
      expected = self.shipping_charge.to_i

      shipping_costs = self.shipments.map do |shipment|
        shipment.cost.to_i
      end
      actual = shipping_costs.inject{|sum,x| sum + x }

      if expected == actual
        "MATCHED"
      elsif expected > actual
        diff = expected - actual
        diff_percent = get_diff_percent diff, expected

        return ["+", diff, diff_percent]
      else
        diff = actual - expected
        diff_percent = get_diff_percent diff, expected

        return ["-", diff, diff_percent]
      end
    else
      ""
    end
  end

  private

  def get_diff_percent diff, expected
    ((diff.to_f / expected.to_f) * 100).to_s.split('.')[0]
  end

  def populate_guid
    self.guid = SecureRandom.hex(4)
  end

end
