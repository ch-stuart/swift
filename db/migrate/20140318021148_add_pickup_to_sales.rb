class AddPickupToSales < ActiveRecord::Migration
  def change
    add_column :sales, :pickup, :string
  end
end
