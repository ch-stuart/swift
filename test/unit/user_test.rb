require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # def add_wholesale_if_user_is_preapproved
  #   if PreApprovedDealer.find_by_email self.email
  #     self.wholesale = true
  #     UsersMailer.new_user(self.email, true).deliver
  #   else
  #     UsersMailer.new_user(self.email, false).deliver
  #   end
  # end

  def setup
    pre_dealer = PreApprovedDealer.new({ email: "ws@bikeshop.com" })
    pre_dealer.save
  end

  test "user should be set up as WS user if they are pre-approved" do
    user = User.new({ email: "ws@bikeshop.com", password: "9B9C1C05-8F5D-47C8-92D4-AB1472596B58" })
    user.save!

    assert user.wholesale, "should be wholesale"
  end

  test "user should NOT be set up as WS user if they are pre-approved" do
    user = User.new({ email: "joe@blow.com", password: "9B9C1C05-8F5D-47C8-92D4-AB1472596B58" })
    user.save

    assert !user.wholesale, "should NOT be wholesale"
  end

end
