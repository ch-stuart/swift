require 'test_helper'

class HubControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    sign_in User.first
  end

  test "should get index" do
    get :index
    assert_template layout: "layouts/hub"
    assert_response :success
  end

end
