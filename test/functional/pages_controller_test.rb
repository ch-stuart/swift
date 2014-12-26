require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    sign_in users(:admin)
    @page = pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page" do
    assert_difference('Page.count') do
      @page.title = 'Uniquely unique'
      @page.path = 'lorem'
      post :create, :page => @page.attributes.except("id", "created_at", "updated_at")
    end

    assert_redirected_to page_path(assigns(:page))
  end

  test "should create more complex page" do
    assert_difference('Page.count') do
      @page = pages(:three)
      @page.title = 'Uniquely unique'
      @page.path = 'lorem'
      post :create, :page => @page.attributes.except("id", "created_at", "updated_at")
    end

    assert_redirected_to page_path(assigns(:page))
  end

  test "should show page" do
    get :show, :id => @page.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @page.to_param
    assert_response :success
  end

  test "should update page" do
    put :update, :id => @page.to_param, :page => @page.attributes.except("id", "created_at", "updated_at")
    assert_redirected_to page_path(assigns(:page))
  end

  test "should destroy page" do
    assert_difference('Page.count', -1) do
      delete :destroy, :id => @page.to_param
    end

    assert_redirected_to pages_path
  end
end
