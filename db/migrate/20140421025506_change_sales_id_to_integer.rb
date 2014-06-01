class ChangeSalesIdToInteger < ActiveRecord::Migration
  def change
    remove_column :shipments, :sale_id
    add_column :shipments, :sale_id, :integer
  end
end
