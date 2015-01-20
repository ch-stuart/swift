require 'test_helper'

class ExceptionsControllerTest < ActionController::TestCase

  test "should get report" do
    post :report, { msg: "we have a problem", format: 'json' }
    assert_response :success
  end

end
