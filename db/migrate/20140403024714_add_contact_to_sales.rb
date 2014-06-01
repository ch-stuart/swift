class AddContactToSales < ActiveRecord::Migration
  def change
    add_column :sales, :contact, :string
  end
end
