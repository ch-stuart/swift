class Sale < ActiveRecord::Base

  has_many :shipments
  has_many :gift_certificates

  attr_accessible :description, :email, :guid, :amount, :weight, :line1, :line2, :city, :state,
  :zip_code, :country, :shipping_provider, :shipping_service, :shipping_charge, :stripe_id, :tax_rate,
  :tax_amount, :total, :pickup, :status, :phone_no, :contact, :company, :commercial, :postmaster_id,
  :shipping_tracking_number, :gift_certificate_guid, :gift_cert_remain, :gift_cert_applied,
  :total_with_gift_cert, :shipping_contact

  before_create :populate_guid

  # validates_presence_of :email, :description
  # validates :email, format: /@/

  STATUSES = ["Not Shipped", "Printed", "Shipped", "Deleted"]
  attr_reader :STATUSES
  validates :status, :inclusion => { :in => STATUSES, :message => "%{value} is not a valid status" }

  validates_presence_of :email, :amount, :total

  scope :sort_by_created_at, order("created_at DESC")

  scope :not_shipped, where(status: 'Not Shipped').sort_by_created_at
  scope :printed,     where(status: 'Printed').sort_by_created_at
  scope :shipped,     where(status: 'Shipped').sort_by_created_at
  scope :deleted,     where(status: 'Deleted').sort_by_created_at

  # This needs to exclude instances where the product hasn't
  # shipped, and isntances where it shipped, but was not shipped
  # with Postmaster
  # def self.get_all_shipping_price_diff
  #   total_actual   = Shipment.sum(:cost)
  #   total_expected = Sale.sum(:shipping_charge)
  #
  #   if (total_expected > total_actual)
  #     diff = total_expected - total_actual
  #     perc = ((diff.to_f / total_expected.to_f) * 100).to_s.split(".")[0]
  #
  #     return ['+', diff, perc]
  #   else
  #     diff = total_actual - total_expected
  #     perc = ((diff.to_f / total_expected.to_f) * 100).to_s.split(".")[0]
  #
  #     return ['-', diff, perc]
  #   end
  # end

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
