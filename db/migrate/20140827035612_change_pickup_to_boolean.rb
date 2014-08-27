class ChangePickupToBoolean < ActiveRecord::Migration
    def up
        add_column :sales, :pickup_tmp, :boolean, :null => false, :default => false

        Sale.where(pickup: 't').update_all(pickup_tmp: true)
        Sale.where(pickup: 'f').update_all(pickup_tmp: false)
        Sale.where(pickup: nil).update_all(pickup_tmp: false)

        remove_column :sales, :pickup
        rename_column :sales, :pickup_tmp, :pickup
    end

    def down
        add_column :sales, :pickup_tmp, :string

        Sale.where(pickup: true).update_all(pickup_tmp: 't')
        Sale.where(pickup: false).update_all(pickup_tmp: nil)

        remove_column :sales, :pickup
        rename_column :sales, :pickup_tmp, :pickup
    end
end
