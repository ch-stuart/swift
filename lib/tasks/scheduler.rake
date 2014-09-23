desc "Prime the Flickr cache"
task :prime_flickr_cache => :environment do
  puts "Priming Flickr cache..."
  FlickrCachePrimer.prime_flickr_cache
  puts "done."
end
