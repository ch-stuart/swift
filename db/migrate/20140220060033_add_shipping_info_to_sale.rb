class AddShippingInfoToSale < ActiveRecord::Migration
  def change
    add_column :sales, :weight,   :string
    add_column :sales, :line1,    :string
    add_column :sales, :line2,    :string
    add_column :sales, :city,     :string
    add_column :sales, :state,    :string
    add_column :sales, :zip_code, :string
    add_column :sales, :country,  :string
  end
end
