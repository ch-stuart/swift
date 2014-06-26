task :deploy, [:remote, :branch, :should_clear_cache] do |t, args|
    if args[:remote].blank?
        puts "Missing remote arg"
    end
    if args[:branch].blank?
        puts "Missing branch arg"
    end

    if args[:remote] == "heroku"
      puts "Are you sure you want to deploy to production??? [yes/no]"
      yesno = STDIN.gets.chomp
    else
      yesno = "yes"
    end

    if yesno == "yes"
      puts "git push #{args[:remote]} #{args[:branch]}:master --force"
      system "git push #{args[:remote]} #{args[:branch]}:master --force"

      if args[:should_clear_cache]
          system "heroku run rails runner Rails.cache.clear --remote #{args[:remote]}"
      end
    else
      puts ""
      puts "ok, nevermind."
      puts ""
    end
end
