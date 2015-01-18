require 'test_helper'

class PreApprovedDealersControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @pre_approved_dealer = pre_approved_dealers(:one)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pre_approved_dealers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pre_approved_dealer" do
    assert_difference('PreApprovedDealer.count') do
      post :create, pre_approved_dealer: { email: "foo@bor.com" }
    end

    assert_redirected_to pre_approved_dealer_path(assigns(:pre_approved_dealer))
  end

  test "should show pre_approved_dealer" do
    get :show, id: @pre_approved_dealer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pre_approved_dealer
    assert_response :success
  end

  test "should update pre_approved_dealer" do
    patch :update, id: @pre_approved_dealer, pre_approved_dealer: { email: "fooo@bar.com" }
    assert_redirected_to pre_approved_dealer_path(assigns(:pre_approved_dealer))
  end

  test "should destroy pre_approved_dealer" do
    assert_difference('PreApprovedDealer.count', -1) do
      delete :destroy, id: @pre_approved_dealer
    end

    assert_redirected_to pre_approved_dealers_path
  end
end
