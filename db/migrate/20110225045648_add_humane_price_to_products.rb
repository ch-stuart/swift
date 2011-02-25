class AddHumanePriceToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :humane_price, :string
  end

  def self.down
    remove_column :products, :humane_price
  end
end
