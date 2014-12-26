require 'test_helper'

class ProductsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    sign_in users(:admin)
    @product = products(:three)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:public_products)
    assert_not_nil assigns(:private_products)
    assert_not_nil assigns(:public_stock)
    assert_not_nil assigns(:private_stock)
    assert_not_nil assigns(:public_accessories)
    assert_not_nil assigns(:private_accessories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      @product.title = "Unique Title"
      @product.short_title = "Unique Title"
      post(:create, :product => @product.attributes.except("id", "created_at", "updated_at"))
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, :id => @product.to_param
    assert_response :success
  end

  test "should show product order" do
    get :order, :id => @product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product.to_param
    assert_response :success
  end

  test "should update product" do
    put :update, :id => @product.to_param, :product => @product.attributes.except("id", "created_at", "updated_at")
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => @product.to_param
    end

    assert_redirected_to products_path
  end
end
