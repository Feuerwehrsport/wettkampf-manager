# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 5.2.0'

# authentication
gem 'cancancan'

# Use HAML for views
gem 'haml-rails'
# Use SimpleForm for Forms
gem 'simple_form'
gem 'cocoon' # nested_form helper

# Draper as model decorator
gem 'draper'

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
gem 'sqlite3'

# for rs232
gem 'rubyserial'
gem 'highline'
gem 'ffi'

gem 'firesport', path: 'firesport'
gem 'firesport-series', path: 'firesport-series'

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-haml_lint'

  gem 'coffeelint'
  gem 'faker'

  # Rubocop
  gem 'rubocop', require: false
  gem 'rubocop-daemon', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'haml_lint', require: false
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
  gem 'therubyracer' # for gitlab
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end
