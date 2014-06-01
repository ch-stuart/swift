if Rails.env == 'production'
  Rails.logger.info 'Using postmaster prod key'
  Postmaster.api_key = ENV['POSTMASTER_PROD_API_KEY']
else
  Rails.logger.info 'Using postmaster test key'
  Postmaster.api_key = ENV['POSTMASTER_TEST_API_KEY']
end

