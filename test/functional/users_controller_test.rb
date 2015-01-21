require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  test "should not be able to view user if not signed in as user" do
    get :my_info
    assert_response 403
  end

  test "should not be able to edit user if not signed in as user" do
    get :edit_my_info
    assert_response 403
  end

  # my_info GET /users/my_info(.:format)
  test "get my info" do
    sign_in users(:ws)

    get :my_info
    assert_response :success
    assert_not_nil assigns(:user)
  end

  # edit_my_info GET /users/edit_my_info(.:format)
  test "edit my info" do
    sign_in users(:ws)

    get :edit_my_info
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should update user" do
    sign_in users(:ws)

    @user = users(:ws)

    put :update, id: @user, user: { line1: "123 New ST" }
    assert_redirected_to my_info_path
  end

  test "should update user via admin" do
    sign_in users(:admin)
    @user = users(:buyer)

    put :update, id: @user, user: { wholesale: false }
    assert_redirected_to users_path
  end

end
