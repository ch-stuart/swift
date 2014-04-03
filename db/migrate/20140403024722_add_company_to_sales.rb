class AddCompanyToSales < ActiveRecord::Migration
  def change
    add_column :sales, :company, :string
  end
end
