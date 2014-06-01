class Company < ActiveRecord::Base

  validates_presence_of :title, :email, :phone, :address, :description

  attr_accessible :title, :email, :phone, :address, :description, :delivery_time, :front_door_sign, :close_shop, :close_shop_message

  def phone_link
      num = self.phone.gsub(/[^0-9]/,'')
      "tel:+#{num}"
  end
end
