task :clear_cache do |t, args|
    system "Rails.cache.clear"
end
