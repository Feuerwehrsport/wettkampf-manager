# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile << /(^[^_\/]|\/[^_])[^\/]*$/
#Rails.application.config.assets.precompile << /controllers*$/


class DisableAssetsLogger
  def initialize(app)
    unless ENV[ 'LOG_ASSETS' ]
      puts "Deactivating asset logging."
      puts "To see asset requests in log, start with LOG_ASSETS=true env variable."
    end

    @app = app
    Rails.application.assets.logger = Logger.new('/dev/null')
  end

  def call(env)
    previous_level = Rails.logger.level
    Rails.logger.level = Logger::ERROR if env['PATH_INFO'].index("/assets/") == 0 && ! ENV[ 'LOG_ASSETS' ]
    @app.call(env)
  ensure
    Rails.logger.level = previous_level
  end
end

Rails.application.config.middleware.insert_before Rails::Rack::Logger, DisableAssetsLogger if Rails.env.development?