class Shipment < ActiveRecord::Base

  belongs_to :sale, touch: true

  validates_presence_of :postmaster_id, :tracking_number, :carrier, :weight, :sale_id, :cost

end
