class SocialService

  def prime_cache instance, cache_key
    if Rails.cache.exist? cache_key
      puts "SocialService: deleting cache"
      Rails.cache.delete cache_key

      puts "SocialService: priming cache"
      instance.get_by_tag "bicycle"
    else
      puts "SocialService: #{cache_key} is not cached. Nothing doing."
    end
  end

end
