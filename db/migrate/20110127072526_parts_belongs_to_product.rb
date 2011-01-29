class PartsBelongsToProduct < ActiveRecord::Migration
  def self.up
    add_column :parts, :product_id, :integer
  end

  def self.down
    remove_column :parts, :product_id
  end
end