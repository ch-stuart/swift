source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.14'
gem 'pg'
gem "thin"
gem 'flickraw', '0.9.7'
gem 'rdiscount'
gem 'nokogiri'
gem 'jquery-rails', '~> 2.2.1'
gem 'dalli' # memcachier
gem 'memcachier' # memcachier
gem 'newrelic_rpm' # https://devcenter.heroku.com/articles/newrelic#cedar
gem 'figaro'

group :assets do
  gem 'sass-rails', '~> 3.2.3 '
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'foreman'
end

group :development do
  gem 'sqlite3'
  gem 'taps'
end