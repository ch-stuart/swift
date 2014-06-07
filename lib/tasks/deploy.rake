task :deploy, [:remote, :branch, :should_clear_cache] do |t, args|
    if args[:remote].blank?
        puts "Missing remote arg"
    end
    if args[:branch].blank?
        puts "Missing branch arg"
    end

    puts "git push #{args[:remote]} #{args[:branch]}"
    system "git push #{args[:remote]} #{args[:branch]}"

    if args[:should_clear_cache]
        system "heroku run rails runner Rails.cache.clear --remote #{args[:remote]}"
    end
end
