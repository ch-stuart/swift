class Sale < ActiveRecord::Base

  attr_accessible :description, :email, :guid, :amount

  before_create :populate_guid

  private

  def populate_guid
    self.guid = SecureRandom.uuid()
  end

end
