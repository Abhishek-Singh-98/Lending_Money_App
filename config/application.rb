require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LendingMoneyApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_job.queue_adapter = :sidekiq
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # 
    if Rails.env != 'production'
      config.generators do |g|
        g.factory_bot dir: 'spec/factories'
      end

      # Ensure FactoryBot loads files from the custom directory
      config.factory_bot.definition_file_paths = ["spec/factories"]
    end
    config.middleware.use ActionDispatch::Session::CookieStore
    config.autoload_paths << Rails.root.join('lib')
  end
end
