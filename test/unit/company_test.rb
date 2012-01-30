require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @company = {
        :title => "Swift Industries",
        :email => "info@builtbyswift.com",
        :phone => "222 222 2222",
        :address => "1212 12th st",
        :description => "all about us",
        :delivery_time => "long long time",
        :front_door_sign => "lorem ipsum dolor est",
        :close_shop => false,
        :close_shop_message => "we're not open"
    }
  end
  
  test "should create company" do
    company = Company.new @company
    assert company.save, "Should save"
  end

  test "should not save company without title" do
    company = Company.new @company.except(:title)
    assert !company.save, "Should not save"
  end

  test "should not save company without email" do
    company = Company.new @company.except(:email)
    assert !company.save, "Should not save"
  end

  test "should not save company without phone" do
    company = Company.new @company.except(:phone)
    assert !company.save, "Should not save"
  end

  test "should not save company without address" do
    company = Company.new @company.except(:address)
    assert !company.save, "Should not save"
  end

  test "should not save company without description" do
    company = Company.new @company.except(:description)
    assert !company.save, "Should not save"
  end

end
