# frozen_string_literal: true

InertiaRails.configure do |config|
  config.version = ViteRuby.digest
  # encrypt_history requires HTTPS (Web Crypto API)
  config.encrypt_history = Rails.env.production?
  config.deep_merge_shared_data = true
end
