class AddWholesaleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wholesale, :boolean, :default => false
  end
end
