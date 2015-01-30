class TwitterController < ApplicationController

  def get_by_tag
    twitter_service = TwitterService.new
    tag = params[:tag]

    @tweets = Rails.cache.fetch("twitter-get-by-tag-#{tag}") do
      twitter_service.get_by_tag tag
    end

    render json: @tweets
  end

end
