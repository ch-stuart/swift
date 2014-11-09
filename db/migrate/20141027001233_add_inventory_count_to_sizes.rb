class AddInventoryCountToSizes < ActiveRecord::Migration
  def change
    add_column :sizes, :inventory_count, :integer
  end
end
