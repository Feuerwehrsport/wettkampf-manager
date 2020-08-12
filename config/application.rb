# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WettkampfManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_controller.include_all_helpers = false
    config.time_zone = 'Berlin'
    config.i18n.default_locale = :de
    config.autoload_paths += %W[#{config.root}/lib #{config.root}/app/models/concerns #{config.root}/app/validators]
    config.active_record.belongs_to_required_by_default = false
    config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end
