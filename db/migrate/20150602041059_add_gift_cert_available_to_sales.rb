class AddGiftCertAvailableToSales < ActiveRecord::Migration
  def change
    add_column :sales, :gift_cert_available, :integer
  end
end
