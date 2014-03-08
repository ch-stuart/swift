class AddShippingProviderToSales < ActiveRecord::Migration
  def change
    add_column :sales, :shipping_provider, :string
  end
end
