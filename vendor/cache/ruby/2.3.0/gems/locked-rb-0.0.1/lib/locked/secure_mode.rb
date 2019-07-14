# frozen_string_literal: true

require 'openssl'

module Locked
  module SecureMode
    def self.signature(user_id)
      OpenSSL::HMAC.hexdigest('sha256', Locked.config.api_key, user_id.to_s)
    end
  end
end
