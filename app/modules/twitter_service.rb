class TwitterService < SocialService

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def get_by_tag tag
    Rails.cache.fetch("twitter-get-by-tag-#{tag}") do
      response = @client.search("##{tag}").take(4)
      tweets = []

      for tweet in response
        image_data = tweet.user.profile_image_url_https

        tweets.push({
          profile_image: "#{image_data.scheme}://#{image_data.host}#{image_data.path}",
          text: tweet.text,
          screen_name: tweet.user.screen_name,
          link: "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
        })
      end

      tweets.to_json
    end
  end

  def prime_cache
    super self, "twitter-get-by-tag-swiftcampout"
  end

end
