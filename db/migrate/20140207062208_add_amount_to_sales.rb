class AddAmountToSales < ActiveRecord::Migration
  def change
    add_column :sales, :amount, :string
  end
end
