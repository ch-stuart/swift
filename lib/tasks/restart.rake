desc 'Restart app on dreamhost'
task :dh_restart do
  puts "=> restart app"
  puts "touch #{Rails.root.to_s}/tmp/restart.txt"
  system "touch #{ENV['RAILS_ROOT']}/tmp/restart.txt"
end

