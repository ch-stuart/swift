class AddNotForSaleToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :not_for_sale, :boolean, :null => false, :default => false
    add_column :products, :not_for_sale_message, :text, :default => "This product is currently not for sale. Please check back later."
    add_column :companies, :close_shop, :boolean, :null => false, :default => false
    add_column :companies, :close_shop_message, :text, :default => "The shop is currently closed. Please check back later."
  end

  def self.down
    remove_column :products, :not_for_sale
    remove_column :products, :not_for_sale_message
    remove_column :companies, :close_shop
    remove_column :companies, :close_shop_message
  end
end
