source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'

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
gem 'axlsx_rails'
gem 'axlsx', '~> 3.0.0.pre'
gem 'prawn'
gem 'prawn-table'
gem 'prawnto'
gem 'rqrcode_png'
gem 'prawn-qrcode'

# for windows time zones
gem 'tzinfo-data'

gem 'nokogiri'
gem 'json'
gem 'sqlite3'

# for rs232
gem 'rubyserial'
gem 'highline'
gem 'ffi', '~> 1.9.0'

gem 'firesport', path: 'firesport'
gem 'firesport-series', path: 'firesport-series'

group :development do
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'faker'
  gem 'coffeelint'
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
end

group :test do
  # Test with Rspec and Capybara
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'database_cleaner'
  gem 'connection_pool'
  gem 'capybara'
  gem 'poltergeist'
  gem 'factory_bot_rails'
end
