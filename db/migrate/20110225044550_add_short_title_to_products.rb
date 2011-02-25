class AddShortTitleToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :short_title, :string
  end

  def self.down
    remove_column :products, :short_title
  end
end
