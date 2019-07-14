# frozen_string_literal: true

module Locked
  # general error
  class Error < RuntimeError; end
  # Raised when anything is wrong with the request (any unhappy path)
  # This error indicates that either we would wait too long for a response or something
  # else happened somewhere in the middle and we weren't able to get the results
  class RequestError < Locked::Error
    attr_reader :reason

    # @param reason [Exception] the core exception that causes this error
    def initialize(reason)
      @reason = reason
    end
  end
  # security error
  class SecurityError < Locked::Error; end
  # wrong configuration error
  class ConfigurationError < Locked::Error; end
  # error returned by api
  class ApiError < Locked::Error; end

  # api error bad request 400
  class BadRequestError < Locked::ApiError; end
  # api error forbidden 403
  class ForbiddenError < Locked::ApiError; end
  # api error not found 404
  class NotFoundError < Locked::ApiError; end
  # api error user unauthorized 419
  class UserUnauthorizedError < Locked::ApiError; end
  # api error invalid param 422
  class InvalidParametersError < Locked::ApiError; end
  # api error unauthorized 401
  class UnauthorizedError < Locked::ApiError; end
  # all internal server errors
  class InternalServerError < Locked::ApiError; end

  # impersonation command failed
  class ImpersonationFailed < Locked::ApiError; end
end
