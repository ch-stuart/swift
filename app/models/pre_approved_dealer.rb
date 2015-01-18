class PreApprovedDealer < ActiveRecord::Base

  validates_uniqueness_of :email

end
