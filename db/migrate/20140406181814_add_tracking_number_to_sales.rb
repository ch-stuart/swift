class AddTrackingNumberToSales < ActiveRecord::Migration
  def change
    add_column :sales, :shipping_tracking_number, :string
  end
end
