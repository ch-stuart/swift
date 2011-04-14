class DeliveryToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :delivery_time, :text
  end

  def self.down
    remove_column :companies, :delivery_time
  end
end
