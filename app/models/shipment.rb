class Shipment < ActiveRecord::Base

  belongs_to :sale

  attr_accessible :postmaster_id, :tracking_number, :carrier, :weight, :width, :height, :length, :sale_id

  validates_presence_of :postmaster_id, :tracking_number, :carrier, :weight, :width, :height, :length, :sale_id

end
