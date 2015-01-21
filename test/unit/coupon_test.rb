require 'test_helper'

class CouponTest < ActiveSupport::TestCase

  test "should save" do
    coupon = Coupon.new({
      title: "The best coupon",
      code: "ABC123",
      cents_off: 10000
    })
    assert coupon.save, "should save"
  end

  test "should not save with both cents_off and percent_off" do
    coupon = Coupon.new({
      title: "The best coupon",
      code: "ABC123",
      cents_off: 10000,
      percent_off: 50
    })
    assert !coupon.save, "should not save"
  end

end
