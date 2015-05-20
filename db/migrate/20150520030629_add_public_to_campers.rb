class AddPublicToCampers < ActiveRecord::Migration
  def change
    add_column :campers, :public, :boolean, null: false, default: false
  end
end
