require 'test_helper'

class GiftCertificateTest < ActiveSupport::TestCase

  def setup
    @gift_cert = {
      amount: 1000
    }
  end

  test "should create gift certificate" do
    gift_cert = GiftCertificate.new @gift_cert
    assert gift_cert.save, "should save gift cert"
  end

  test "should add guid attr" do
    gift_cert = GiftCertificate.new @gift_cert
    gift_cert.save

    assert(gift_cert.guid.nil? == false)
  end

  test "should add remaining_amount attr" do
    gift_cert = GiftCertificate.new @gift_cert
    gift_cert.save

    assert_equal gift_cert.remaining_amount, 1000
  end

  # kinda dumb that GiftCertificate doesn't own
  # the logic around updating remaining amount.
  # currently managed in sales_controller.rb
  test "should update remaining_amount attr" do
    gift_cert = GiftCertificate.new @gift_cert
    gift_cert.save

    gift_cert.remaining_amount = 500
    gift_cert.save

    assert_equal gift_cert.remaining_amount, 500
  end

end
