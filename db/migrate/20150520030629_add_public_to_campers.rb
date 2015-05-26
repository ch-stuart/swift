class AddPublicToCampers < ActiveRecord::Migration
  def change
    add_column :campers, :is_public, :boolean, null: false, default: false
  end
end
