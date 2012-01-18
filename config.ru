# This file is used by Rack-based servers to start the application.

if FileTest.exists? "/home/enure/.dreamhost"
  ENV['GEM_HOME']="#{ENV['HOME']}/.gems"
  ENV['GEM_PATH']="#{ENV['GEM_HOME']}:/usr/lib/ruby/gems/1.8"
  require 'rubygems'
  Gem.clear_paths
end

require ::File.expand_path('../config/environment',  __FILE__)
run SwiftSite::Application