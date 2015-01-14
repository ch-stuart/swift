require 'test_helper'

class SaleTest < ActiveSupport::TestCase

  def setup
    @sale = {
      email: "bud@pal.com",
      amount: 1000,
      total: 1000
    }
  end

  test "should save" do
    sale = Sale.new @sale
    assert sale.save, "should save"
  end

  test "should create guid" do
    sale = Sale.new @sale
    sale.save
    assert sale.guid.nil? == false, "guid should be present"
  end

  test "should set status" do
    sale = Sale.new @sale
    sale.save
    assert sale.status == "Not Shipped", "status should be set"
  end

end
