class AddPriceToColors < ActiveRecord::Migration
  def self.up
    add_column :colors, :price, :string
  end

  def self.down
    remove_column :colors, :price
  end
end
