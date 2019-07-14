# frozen_string_literal: true

module Locked
  # this class is responsible for making requests to api
  module API
    # Errors we handle internally
    HANDLED_ERRORS = [
      Timeout::Error,
      Errno::EINVAL,
      Errno::ECONNRESET,
      EOFError,
      Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError,
      Net::ProtocolError
    ].freeze

    private_constant :HANDLED_ERRORS

    class << self
      def request(command, headers = {})
        raise Locked::ConfigurationError, 'configuration is not valid' unless Locked.config.valid?

        begin
          Locked::API::Response.call(
            Locked::API::Request.call(
              command,
              Locked.config.api_key,
              headers
            )
          )
        rescue *HANDLED_ERRORS => error
          # @note We need to initialize the error, as the original error is a cause for this
          # custom exception. If we would do it the default Ruby way, the original error
          # would get converted into a string
          raise Locked::RequestError.new(error) # rubocop:disable Style/RaiseArgs
        end
      end
    end
  end
end
