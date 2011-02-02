class RemoveIdFromParts < ActiveRecord::Migration
  def self.up
    remove_column :parts, :color_id
  end

  def self.down
    add_column :parts, :color_id, :integer
  end
end
