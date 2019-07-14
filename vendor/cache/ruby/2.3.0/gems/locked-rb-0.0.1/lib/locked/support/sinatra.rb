# frozen_string_literal: true

require 'sinatra/base'

module Sinatra
  module Locked
    module Helpers
      def locked
        @locked ||= ::Locked::Client.from_request(request)
      end
    end

    def self.registered(app)
      app.helpers Locked::Helpers
    end
  end

  register locked
end
