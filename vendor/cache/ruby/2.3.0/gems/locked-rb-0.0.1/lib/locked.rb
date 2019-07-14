# frozen_string_literal: true

%w[
  openssl
  net/http
  json
  time
].each(&method(:require))

%w[
  locked/version
  locked/errors
  locked/command
  locked/utils
  locked/utils/merger
  locked/utils/cloner
  locked/utils/timestamp
  locked/validators/present
  locked/validators/not_supported
  locked/context/merger
  locked/context/sanitizer
  locked/context/default
  locked/commands/identify
  locked/commands/authenticate
  locked/commands/review
  locked/configuration
  locked/failover_auth_response
  locked/client
  locked/header_formatter
  locked/secure_mode
  locked/extractors/client_id
  locked/extractors/headers
  locked/extractors/ip
  locked/api/response
  locked/api/request
  locked/api/request/build
  locked/review
  locked/api
].each(&method(:require))

# main sdk module
module Locked
  class << self
    def configure(config_hash = nil)
      (config_hash || {}).each do |config_name, config_value|
        config.send("#{config_name}=", config_value)
      end

      yield(config) if block_given?
    end

    def config
      @configuration ||= Locked::Configuration.new
    end

    def api_key=(api_key)
      config.api_key = api_key
    end
  end
end
