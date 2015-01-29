class TwitterController < ApplicationController

  def get_by_tag
    tag = params[:tag]
    client = get_client

    @tweets = Rails.cache.fetch("twitter-get-by-tag-#{tag}") do
      client.search("##{tag}").take(15).to_json
    end

    render json: @tweets
  end

  private

  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

end
