require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rack'
require 'rack/http/signatures'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleRackHttpSignatures
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.use Rack::Http::Signatures::VerifySignature do |config|
      config.public_rsa_sha256_key_from_keyid { |key_id| User.find_by(email: key_id).public_rsa256_key }
      config.public_hmac_sha256_key_from_keyid { |key_id| User.find_by(email: key_id).hs256_key }
    end
  end
end
