class AddShippingCostToSales < ActiveRecord::Migration
  def change
      add_column :sales, :shipping_charge, :string
      add_column :sales, :shipping_service, :string
  end
end
