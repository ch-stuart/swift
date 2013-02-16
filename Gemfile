source :rubygems
ruby '1.9.3'

gem 'rails', '3.1.11'
gem "thin"
gem 'flickraw', '0.9.5'
# faster?
# gem 'flickraw-cached'
gem 'rdiscount'
gem 'nokogiri'
gem 'jquery-rails'
gem 'dalli' # memcache
gem 'newrelic_rpm' # https://devcenter.heroku.com/articles/newrelic#cedar

group :assets do
  gem 'sass-rails', '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'pg'
  gem "foreman"
end

group :development do
  gem 'sqlite3'
  gem 'taps'
  gem 'heroku'
end