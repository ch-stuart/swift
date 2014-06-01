class AddTaxAmountToSales < ActiveRecord::Migration
  def change
    add_column :sales, :tax_amount, :string
  end
end
