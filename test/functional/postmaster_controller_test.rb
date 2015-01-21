require 'test_helper'

class PostmasterControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  # post 'postmaster/validate'
  test "should validate address" do
    post :validate, { line1: "420 South Ave E", city: "Missoula", state: "MT", zip_code: "59801", format: 'json' }
    Rails.logger.info @response.body
    assert_response :success
    assert_not_nil JSON.parse(@response.body)['status']

  end

  # post 'postmaster/rates'
  test "should get rates" do
    # from_zip
    # to_zip
    # weight
    post "rates", { from_zip: "98122", to_zip: "59801", weight: "1.0" }
    Rails.logger.info @response.body
    assert_response :success
    assert_not_nil JSON.parse(@response.body)['best']
  end

  # don't need to test this b/c we don't use it
  # post 'postmaster/fit'
  # test "should fit boxes" do
  #
  # end

  # get  'postmaster/edit_shipment'
  test "should edit a shipment" do
    sign_in users(:admin)

    get "edit_shipment", { id: sales(:one).id }

    assert_not_nil assigns(:sale)
    assert_not_nil assigns(:boxes)

    assert_response :success
  end

  # post 'postmaster/create_shipment'
  test "should create a shipment" do
    sign_in users(:admin)

    post "create_shipment", {
      id: sales(:one).id,
      shipment: {
        contact: "bob",
        company: "bobs company",
        line1: "420 South AVE E",
        city: "Missoula",
        state: "MT",
        zip_code: "59801",
        country: "US",
        phone_no: "1 406 222 2222",
        shipping_provider: "USPS",
        shipping_service: "GROUND",
        weight: "1.0",
        width: "4",
        height: "4",
        length: "4"
       }
    }

    assert_redirected_to sale_path(assigns(:sale))
  end

  # get  'postmaster/boxes'
  test "should get boxes" do
    sign_in users(:admin)

    get "boxes"
    assert_response :success
  end

  # post 'postmaster/create_box'
  # test "should create boxes" do
  #   sign_in users(:admin)
  #
  #
  # end

end
