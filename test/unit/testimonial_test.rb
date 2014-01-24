require 'test_helper'

class TestimonialTest < ActiveSupport::TestCase

  def setup
    @testimonial = {
      :body => "lorem ipsum dolor est",
      :author => "dougie"
    }
  end

  test "should create testimonial" do
    t = Testimonial.new @testimonial
    assert t.save, "should save"
  end

  test "should not save without body" do
    t = Testimonial.new @testimonial.except(:body)
    assert !t.save, "should not save"
  end

  test "should not save without author" do
    t = Testimonial.new @testimonial.except(:author)
    assert !t.save, "should not save"
  end

end
