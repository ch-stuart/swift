class AddTaxRateToSales < ActiveRecord::Migration
  def change
    add_column :sales, :tax_rate, :string
  end
end
