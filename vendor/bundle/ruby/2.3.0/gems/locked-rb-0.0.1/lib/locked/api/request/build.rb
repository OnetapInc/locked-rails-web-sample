# frozen_string_literal: true

module Locked
  module API
    # generate api request
    module Request
      module Build
        class << self
          API_KEY_HEADER = 'X-LOCKED-API-KEY'
          def call(command, headers, api_key)
            headers[API_KEY_HEADER] = api_key
            request = Net::HTTP.const_get(
              command.method.to_s.capitalize
            ).new("/#{Locked.config.url_prefix}/#{command.path}", headers)

            command.data.delete(:context) # TODO: use context in request
            unless command.method == :get
              request.body = ::Locked::Utils.replace_invalid_characters(
                command.data
              ).to_json
            end

            request
          end
        end
      end
    end
  end
end
