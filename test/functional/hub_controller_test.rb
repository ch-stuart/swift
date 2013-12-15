require 'test_helper'

class HubControllerTest < ActionController::TestCase
  setup do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("builder:buildhandmadecommunity")
  end

  test "should get index" do
    get :index
    assert_template layout: "layouts/hub"
    assert_response :success
  end

end
