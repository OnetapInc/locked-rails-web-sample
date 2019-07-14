# frozen_string_literal: true

module Locked
  module API
    # parses api response
    module Response
      RESPONSE_ERRORS = {
        400 => Locked::BadRequestError,
        401 => Locked::UnauthorizedError,
        403 => Locked::ForbiddenError,
        404 => Locked::NotFoundError,
        419 => Locked::UserUnauthorizedError,
        422 => Locked::InvalidParametersError
      }.freeze

      class << self
        def call(response)
          verify!(response)

          return {} if response.body.nil? || response.body.empty?

          begin
            JSON.parse(response.body, symbolize_names: true)
          rescue JSON::ParserError
            raise Locked::ApiError, 'Invalid response from Locked API'
          end
        end

        def verify!(response)
          return if response.code.to_i.between?(200, 299)

          raise Locked::InternalServerError if response.code.to_i.between?(500, 599)

          error = RESPONSE_ERRORS.fetch(response.code.to_i, Locked::ApiError)
          raise error, response[:message]
        end
      end
    end
  end
end
