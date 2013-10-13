class AddWholesalePriceFields < ActiveRecord::Migration

  def change
      add_column :products, :wholesale_humane_price, :string
      add_column :products, :wholesale_price, :string
      add_column :sizes, :wholesale_price, :string
      add_column :colors, :wholesale_price, :string
      add_column :parts, :wholesale_price, :string
  end

end
