task :prime_flickr_cache => :environment do
  FlickrCachePrimer.prime_cache
end

task :prime_twitter_cache => :environment do
  twitter_service = TwitterService.new
  twitter_service.prime_cache
end

task :prime_instagram_cache => :environment do
  instagram_service = InstagramService.new
  instagram_service.prime_cache
end
