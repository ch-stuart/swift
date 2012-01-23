source :rubygems

gem 'rails', '3.1.3'
gem 'flickraw', '0.8.3'
gem 'rdiscount'
gem 'sqlite3'
gem 'nokogiri'
gem 'json'
gem 'jquery-rails'
# this used to be reqd on dreamhost.
# gem 'sqlite3-ruby', '1.2.1', :require => 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'uglifier'
end

group :production do
  gem 'therubyracer'
  gem 'uglifier'
  gem 'sass-rails'
  # this is for heroku
  # gem 'pg'
end

# # heroku does not install this group, because heroku
# # installs exceptional by 'magic'
# group :dreamhost do
#   # gem 'exceptional'
# end
# 
# group :development do
#   # gem 'yaml_db'
# end