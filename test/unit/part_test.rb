require 'test_helper'

class PartTest < ActiveSupport::TestCase

  def setup
    @part = {
      :title => "dogs",
      :price => "12.22"
    }
  end
  
  test "should save" do
    part = Part.new @part
    assert part.save, "should save"
  end
  
  test "should require title" do
    part = Part.new @part.except(:title)
    assert !part.save, "should not save"
  end
  
  test "should require good price" do
    @part[:price] = "$12.22"
    part = Part.new @part
    assert !part.save, "should not save"
  end

end
