class AddFlatRateShippingChargeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :domestic_flat_rate_shipping_charge, :integer
    add_column :products, :international_flat_rate_shipping_charge, :integer
  end
end
