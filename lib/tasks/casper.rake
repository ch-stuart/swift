task :casper do |t, args|
  system "casperjs test test/casperjs/*"
end

