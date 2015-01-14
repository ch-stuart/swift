class Company < ActiveRecord::Base

  validates_presence_of :title, :email, :phone, :address, :description

  def phone_link
      num = self.phone.gsub(/[^0-9]/,'')
      "tel:+#{num}"
  end
end
