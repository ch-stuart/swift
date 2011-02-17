desc 'Compile Sass Stylesheets and then run Jammit'
task :package_assets => :environment do
  puts "=> Packaging assets."
  Sass::Plugin.update_stylesheets
  Jammit.package!
end

