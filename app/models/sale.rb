class Sale < ActiveRecord::Base

  attr_accessible :description, :email, :guid, :amount, :weight, :line1, :line2, :city, :state, :zip_code, :country, :shipping_provider, :shipping_service, :shipping_charge, :stripe_id, :tax_rate, :tax_amount, :total, :pickup, :status, :phone_no, :contact, :company, :commercial, :postmaster_id

  before_create :populate_guid

  # validates_presence_of :email, :description
  # validates :email, format: /@/

  STATUSES = ["Not Shipped", "Shipped"]
  attr_reader :STATUSES
  validates :status, :inclusion => { :in => STATUSES, :message => "%{value} is not a valid status" }

  validates_presence_of :email, :amount, :total, :stripe_id

  has_many :packages

  private

  def populate_guid
    self.guid = SecureRandom.hex(4)
  end

end
