# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)

Rails.application.load_tasks


require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop) #.tap { |task| task.options = ['--config .rubocop.yml'] }

task default: %i[spec coffeelint rubocop]