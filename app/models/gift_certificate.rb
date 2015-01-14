class GiftCertificate < ActiveRecord::Base

  belongs_to :sale
  before_create :populate_guid_and_remaining_amount
  before_save :update_remaining_amount, if: "remaining_amount?"

  private

  def populate_guid_and_remaining_amount
    self.guid = SecureRandom.hex(4)
    self.remaining_amount = self.amount
  end

  def update_remaining_amount
    if self.amount > self.amount_was
      self.remaining_amount = (self.amount - self.amount_was) + self.remaining_amount
    else
      self.remaining_amount = self.remaining_amount - (self.amount_was - self.amount)
    end
  end

end
