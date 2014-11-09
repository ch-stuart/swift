class AddIsShippingFlatRateToSales < ActiveRecord::Migration
  def change
    add_column :sales, :shipping_service_is_flat_rate, :boolean
  end
end
