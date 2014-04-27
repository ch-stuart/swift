if Rails.env == 'production'
  Rails.logger.info 'Using Stripe prod key'
  Rails.configuration.stripe = {
    publishable_key: ENV['STRIPE_PROD_PUBLISHABLE_KEY'],
    secret_key:      ENV['STRIPE_PROD_SECRET_KEY'],
  }
  Stripe.api_key = Rails.configuration.stripe[:secret_key]
else
  Rails.logger.info 'Using Stripe prod key'
  Rails.configuration.stripe = {
    publishable_key: ENV['STRIPE_TEST_PUBLISHABLE_KEY'],
    secret_key:      ENV['STRIPE_TEST_SECRET_KEY'],
  }
  Stripe.api_key = Rails.configuration.stripe[:secret_key]
end
