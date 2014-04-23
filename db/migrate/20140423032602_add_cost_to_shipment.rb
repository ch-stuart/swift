class AddCostToShipment < ActiveRecord::Migration
  def change
    add_column :shipments, :cost, :string
  end
end
