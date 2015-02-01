require 'test_helper'

class TwitterServiceTest < ActiveSupport::TestCase

  def setup
    @service = TwitterService.new
  end

  test "should get results from Twitter" do
    response = @service.get_by_tag "coffee"

    Rails.logger.info response

    assert 15, response[0].text.present?, "should have text property"
    assert 15, response[0].user.present?, "should have user property"
  end

end
