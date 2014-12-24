require 'test_helper'

class CouponsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    sign_in User.first
    @coupon = coupons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:coupons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create coupon" do
    assert_difference('Coupon.count') do
      post :create, coupon: {
        code: "UNIQUE_CODE",
        description: @coupon.description,
        end_date: @coupon.end_date,
        percent_off: 10,
        published: @coupon.published,
        start_date: @coupon.start_date,
        title: "Unique Title"
      }
    end

    assert_redirected_to coupon_path(assigns(:coupon))
  end

  test "should show coupon" do
    get :show, id: @coupon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @coupon
    assert_response :success
  end

  test "should update coupon" do
    put :update, id: @coupon, coupon: { cents_off: @coupon.cents_off, code: @coupon.code, description: @coupon.description, end_date: @coupon.end_date, percent_off: @coupon.percent_off, published: @coupon.published, start_date: @coupon.start_date, title: @coupon.title }
    assert_redirected_to coupon_path(assigns(:coupon))
  end

  test "should destroy coupon" do
    assert_difference('Coupon.count', -1) do
      delete :destroy, id: @coupon
    end

    assert_redirected_to coupons_path
  end
end
