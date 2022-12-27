require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<TWILIO_ACCOUNT_SID>") { ENV.fetch("TWILIO_ACCOUNT_SID", nil) }
  config.filter_sensitive_data("<TWILIO_ACCOUNT_TOKEN>") { ENV.fetch("TWILIO_ACCOUNT_TOKEN", nil) }
  config.filter_sensitive_data("<TWILIO_VERIFY_SERVICE_ID>") do
    ENV.fetch("TWILIO_VERIFY_SERVICE_ID", nil)
  end
  config.configure_rspec_metadata!
end