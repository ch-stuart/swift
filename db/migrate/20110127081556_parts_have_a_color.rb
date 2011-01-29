class PartsHaveAColor < ActiveRecord::Migration
  def self.up
    add_column :parts, :color_id, :integer
  end

  def self.down
    remove_column :parts, :color_id
  end
end
