require 'test_helper'

class SizeTest < ActiveSupport::TestCase

  def setup
    @size = {
      :title => "Large",
      :price => "12.00"
    }
  end

  test "should save" do
    size = Size.new @size
    assert size.save, "should save"
  end

  test "should not save with invalid price" do
    @size[:price] = "bogus"
    size = Size.new @size
    assert !size.save, "should not save"
  end

  test "should not save without title" do
    size = Size.new @size.except(:title)
    assert !size.save, "should not save"
  end

end
