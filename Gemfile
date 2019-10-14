source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'

# authentication
gem 'cancancan'

# Use HAML for views
gem 'haml-rails'
# Use SimpleForm for Forms
gem 'simple_form'
gem 'cocoon' # nested_form helper

# Draper as model decorator
gem 'draper'

# Carrierwave for file uploads
gem 'carrierwave'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'bootstrap-sass'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
gem 'coffee-script-source'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# exports
gem 'caxlsx'
gem 'prawn'
gem 'prawn-table'
gem 'prawn-qrcode'

# for windows time zones
gem 'tzinfo-data'

gem 'nokogiri'
gem 'json'
gem 'sqlite3', '~> 1.3.0'

# for rs232
gem 'rubyserial'
gem 'highline'
gem 'ffi'

gem 'firesport', path: 'firesport'
gem 'firesport-series', path: 'firesport-series'

group :development do
  gem 'coffeelint'
  gem 'faker'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rubocop', require: false
  gem 'rubocop-daemon', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
end

group :test do
  # Test with Rspec and Capybara
  gem 'capybara'
  gem 'connection_pool'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'poltergeist'
  gem 'rails-controller-testing'
  gem 'rspec-collection_matchers'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end
