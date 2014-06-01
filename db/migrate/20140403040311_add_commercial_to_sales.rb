class AddCommercialToSales < ActiveRecord::Migration
  def change
    add_column :sales, :commercial, :string
  end
end
