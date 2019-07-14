# frozen_string_literal: true

module Locked
  module Extractors
    # used for extraction of cookies and headers from the request
    class ClientId
      def initialize(request, cookies)
        @request = request
        @cookies = cookies || {}
      end

      def call
        @request.env['HTTP_X_LOCKED_CLIENT_ID'] || @cookies['__cid'] || ''
      end
    end
  end
end
