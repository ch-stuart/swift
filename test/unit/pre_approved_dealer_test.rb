require 'test_helper'

class PreApprovedDealerTest < ActiveSupport::TestCase

  test "pre-approved dealer should save" do
      dealer = PreApprovedDealer.new({
        email: "hooha@hooha.com"
      })
      assert dealer.save, "should save!"
  end

  test "pre-approved dealer should not save" do
      dealer = PreApprovedDealer.new
      assert !dealer.save, "should not save!"
  end

end
