# frozen_string_literal: true

module Locked
  # this class is responsible for making requests to api
  module API
    module Request
      # Default headers that we add to passed ones
      DEFAULT_HEADERS = {
        'Content-Type' => 'application/json'
      }.freeze

      private_constant :DEFAULT_HEADERS

      class << self
        def call(command, api_key, headers)
          http.request(
            Locked::API::Request::Build.call(
              command,
              headers.merge(DEFAULT_HEADERS),
              api_key
            )
          )
        end

        def http
          http = Net::HTTP.new(Locked.config.host, Locked.config.port)
          http.read_timeout = Locked.config.request_timeout / 1000.0
          if Locked.config.port == 443
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          end
          http
        end
      end
    end
  end
end
