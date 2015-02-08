class TwitterController < ApplicationController

  def get_by_tag
    twitter_service = TwitterService.new
    tweets = twitter_service.get_by_tag params[:tag]

    render json: tweets
  end

end
