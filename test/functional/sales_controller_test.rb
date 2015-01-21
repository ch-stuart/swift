require 'test_helper'

class SalesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    sign_in users(:admin)
    @sale = sales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success

    assert_not_nil assigns(:sales_not_shipped)
    assert_not_nil assigns(:sales_printed)
    assert_not_nil assigns(:sales_shipped)
    assert_not_nil assigns(:sales_deleted)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale" do
    assert_difference('Sale.count') do
      post :create, { email: @sale.email, amount: 111, total: 333 }
    end

    # assert_redirected_to sale_path(assigns(:sale))
    assert_response :success
  end

  test "should show sale on hub" do
    get :show, id: @sale
    assert_response :success
  end

  test "should show sale to customer" do
    get :success, id: @sale
    assert_response :success
  end

  test "should show order history to customer" do
    sign_in users(:buyer)
    get :history
    assert_equal assigns(:sales).size, 4
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale
    assert_response :success
  end

  test "should update sale" do
    put :update, id: @sale, sale: { email: @sale.email, amount: 111, total: 122 }
    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should destroy sale" do
    assert_difference('Sale.count', -1) do
      delete :destroy, id: @sale
    end

    assert_redirected_to sales_path
  end
end
