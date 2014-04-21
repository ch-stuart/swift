class CreateShipmentsTable < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :postmaster_id
      t.string :tracking_number
      t.string :carrier
      t.string :weight
      t.string :width
      t.string :height
      t.string :length
      t.string :sale_id

      t.timestamps
    end

    remove_column :sales, :postmaster_id
    remove_column :sales, :shipping_tracking_number
  end
end
