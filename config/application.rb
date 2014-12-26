require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # # If you precompile assets before deploying to production, use this line
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  # # If you want your assets lazily compiled in production, use this line
  # # Bundler.require(:default, :assets, Rails.env)

  # Require the gems listed in Gemfile, including any gems
  # you've limited to :test, :development, or :production.
  Bundler.require(:default, Rails.env)
end

module SwiftSite
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/app/sweepers)
    config.autoload_paths += %W(#{config.root}/app/modules)
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # config.action_controller.page_cache_directory = "#{config.root}/public/cache"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # heroku requires this to be false
    config.assets.initialize_on_precompile = false

    # let rails know about bower components
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

    ActionMailer::Base.smtp_settings = {
        port:           '587',
        address:        'smtp.mandrillapp.com',
        user_name:      ENV['MANDRILL_STAGING_USERNAME'],
        password:       ENV['MANDRILL_STAGING_APIKEY'],
        domain:         'heroku.com',
        authentication: :plain
    }
    ActionMailer::Base.delivery_method = :smtp
    config.action_mailer.default_url_options = {
      :host => 'fierce-island-8829.herokuapp.com'
    }

  end
end
