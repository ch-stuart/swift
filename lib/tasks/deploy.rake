namespace :deploy do

    task :production do
        puts "=== deploying to production"
        system "git push heroku"
        puts "=== clearing cache"
        system "heroku console Rails.cache.clear"
        puts "=== done"
    end

end