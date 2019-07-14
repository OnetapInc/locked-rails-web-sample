# frozen_string_literal: true

module Locked
  module Hanami
    module Action
      def locked
        @locked ||= ::Locked::Client.from_request(request, cookies: (cookies if defined? cookies))
      end
    end

    def self.included(base)
      base.configure do
        controller.prepare do
          include Locked::Hanami::Action
        end
      end
    end
  end
end
