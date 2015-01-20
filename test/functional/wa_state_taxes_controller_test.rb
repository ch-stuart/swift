require 'test_helper'

class WaStateTaxesControllerTest < ActionController::TestCase

  test "can get rate" do
    post :rate
    assert_response :success
  end

  test "gets back empty JSON response for no params" do
    post :rate
    assert_nil JSON.parse(@response.body)['rate']
  end

  test "gets back empty JSON response for MI zip" do
    post :rate, {
      addr: "2568 North Meridian Road",
      city: "Mount Pleasant",
      zip: "48858",
      output: "xml"
    }
    assert_nil JSON.parse(@response.body)['rate']
  end

  test "gets back non-empty JSON response for WA zip" do
    post :rate, {
      addr: "1223 NW 49th Street",
      city: "Seattle",
      zip: "98122",
      output: "xml"
    }
    assert_response :success
    assert_not_nil JSON.parse(@response.body)['rate']
  end

end
