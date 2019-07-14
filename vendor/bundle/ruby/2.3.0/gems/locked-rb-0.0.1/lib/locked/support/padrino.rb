# frozen_string_literal: true

module Padrino
  class Application
    module Locked
      module Helpers
        def locked
          @locked ||= ::Locked::Client.from_request(request)
        end
      end

      def self.registered(app)
        app.helpers Helpers
      end
    end

    register locked
  end
end
