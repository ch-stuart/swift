class AddPostmasterIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :postmaster_id, :string
  end
end
