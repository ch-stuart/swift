class MakeColorPartJoinTable < ActiveRecord::Migration
  def self.up
    create_table :colors_parts, :id => false do |t|
      t.integer :part_id
      t.integer :color_id
    end
  end

  def self.down
    drop_table :colors_parts
  end
end


