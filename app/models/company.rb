class Company < ActiveRecord::Base

  validates_presence_of :title, :email, :phone, :address, :description
  
end
