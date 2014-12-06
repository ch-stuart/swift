class AddSavedWithCouponToSales < ActiveRecord::Migration
  def change
    add_column :sales, :saved_with_coupon, :integer
  end
end
