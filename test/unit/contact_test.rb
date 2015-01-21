require 'test_helper'

class ContactTest < ActiveSupport::TestCase

  test "contact should save" do
      contact = Contact.new({
        email: "cat@lala.com"
      })
      assert contact.save, "should save!"
  end

end
