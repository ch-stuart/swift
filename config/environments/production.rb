SwiftSite::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  # no, b/c heroku doesn't front with nginx or apache
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Cache static assets for 1 year
  config.static_cache_control = "public, max-age=31536000"

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # http://devcenter.heroku.com/articles/memcache
  config.cache_store = :dalli_store

  # fix for heroku
  config.assets.precompile += %w( application-hub.css  )

  # REMOVED Uglifier 2.x does not support this...,
  # at least with this method signature. cstuart 2013-10-03
  # Ensure this only runs in the :assets bundler group
  # https://gist.github.com/toolmantim/3184063
  # if defined? Uglifier
  #   config.assets.js_compressor = Uglifier.new(
  #     # Add new lines
  #     :beautify => true,
  #     # Don't add indentation
  #     :beautify_options => {:indent_level => 0}
  #   )
  # end

  config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[Exception at builtbyswift.com] ",
      :sender_address => %{"notifier" <admin@builtbyswift.com>},
      :exception_recipients => %w{app.logging@builtbyswift.com}
    }

  ActionMailer::Base.smtp_settings = {
      port:           '587',
      address:        'smtp.mandrillapp.com',
      user_name:      ENV['MANDRILL_PRODUCTION_USERNAME'],
      password:       ENV['MANDRILL_PRODUCTION_APIKEY'],
      domain:         'heroku.com',
      authentication: :plain
  }
  ActionMailer::Base.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    :host => 'www.builtbyswift.com'
  }

  config.eager_load = true
end

