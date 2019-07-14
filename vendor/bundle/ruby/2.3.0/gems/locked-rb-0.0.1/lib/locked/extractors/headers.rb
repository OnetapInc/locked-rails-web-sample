# frozen_string_literal: true

module Locked
  module Extractors
    # used for extraction of cookies and headers from the request
    class Headers
      def initialize(request)
        @request = request
        @request_env = @request.env
        @formatter = HeaderFormatter.new
      end

      # Serialize HTTP headers
      def call
        @request_env.keys.each_with_object({}) do |header, acc|
          name = @formatter.call(header)
          next unless Locked.config.whitelisted.include?(name)
          next if Locked.config.blacklisted.include?(name)
          acc[name] = @request_env[header]
        end
      end
    end
  end
end
