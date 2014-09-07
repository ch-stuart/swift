class AddShippingContactToSales < ActiveRecord::Migration
  def change
    add_column :sales, :shipping_contact, :text
  end
end
