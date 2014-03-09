class AddStripeIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :stripe_id, :string
  end
end
