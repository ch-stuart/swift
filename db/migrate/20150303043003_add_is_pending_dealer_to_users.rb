class AddIsPendingDealerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_pending_wholesale, :boolean, null: false, default: false
  end
end
