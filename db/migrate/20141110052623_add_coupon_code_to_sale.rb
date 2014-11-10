class AddCouponCodeToSale < ActiveRecord::Migration
  def change
    add_column :sales, :coupon_code, :string
  end
end
