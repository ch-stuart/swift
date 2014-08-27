class ChangeCommercialToBoolean < ActiveRecord::Migration
    def up
        add_column :sales, :commercial_tmp, :boolean, :null => false, :default => false

        Sale.where(commercial: 't').update_all(commercial_tmp: true)
        Sale.where(commercial: 'f').update_all(commercial_tmp: false)
        Sale.where(commercial: nil).update_all(commercial_tmp: false)

        remove_column :sales, :commercial
        rename_column :sales, :commercial_tmp, :commercial
    end

    def down
        add_column :sales, :commercial_tmp, :string

        Sale.where(commercial: true).update_all(commercial_tmp: 't')
        Sale.where(commercial: false).update_all(commercial_tmp: nil)

        remove_column :sales, :commercial
        rename_column :sales, :commercial_tmp, :commercial
    end
end
