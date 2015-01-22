source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '~> 4.0.0'
gem 'pg', '0.17.1'
gem "thin"
gem 'flickraw', '0.9.8'
gem 'rdiscount'
gem 'nokogiri'
gem 'dalli' # memcachier
gem 'memcachier' # memcachier
gem 'newrelic_rpm' # https://devcenter.heroku.com/articles/newrelic#cedar
gem 'figaro'
gem 'stripe'
gem 'mandrill-api'
gem 'postmaster'
gem 'httpclient'
gem 'exception_notification'
gem 'rack-rewrite'
gem 'devise'
gem 'cacheable_flash'
gem 'awesome_print'
gem 'rails_12factor'
gem 'actionpack-action_caching'
gem 'rails-observers'
gem 'cocoon'

# group :assets do
  gem 'sass-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0'
  gem "autoprefixer-rails"
  gem "underscore-rails"
  gem 'jquery-rails', '~> 3.1.2'
  gem 'angularjs-rails', '~> 1.2.26'
# end

group :production do
  gem 'foreman'
  gem 'heroku_rails_deflate'
end

group :development do
  gem 'sqlite3'
  gem 'taps'
  gem 'guard'
  gem 'guard-test'
  gem 'guard-shell'
  gem 'brakeman'
  gem 'table_print'
end

# Wah. Not compatible with guard-test
# group :test do
#   gem 'turn'
# end
