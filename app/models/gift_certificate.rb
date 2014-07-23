class GiftCertificate < ActiveRecord::Base
  attr_accessible :amount, :guid, :sale_id, :remaining_amount

  before_create :populate_guid_and_remaining_amount

  private

  def populate_guid_and_remaining_amount
    self.guid = SecureRandom.hex(4)
    self.remaining_amount = self.amount
  end

end
