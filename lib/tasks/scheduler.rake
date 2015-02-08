task :prime_flickr_cache => :environment do
  begin
    FlickrCachePrimer.prime_cache
  rescue Exception => e
    ExceptionNotifier.notify_exception(
      e,
      env: request.env,
      data: { message: "Priming flickr cache failed" }
    )
    puts e
  end
end

task :prime_twitter_cache => :environment do
  begin
    twitter_service = TwitterService.new
    twitter_service.prime_cache
  rescue Exception => e
    ExceptionNotifier.notify_exception(
      e,
      env: request.env,
      data: { message: "Priming twitter cache failed" }
    )
    puts e
  end
end

task :prime_instagram_cache => :environment do
  begin
    instagram_service = InstagramService.new
    instagram_service.prime_cache
  rescue Exception => e
    ExceptionNotifier.notify_exception(
      e,
      env: request.env,
      data: { message: "Priming instagram cache failed" }
    )
    puts e
  end
end
