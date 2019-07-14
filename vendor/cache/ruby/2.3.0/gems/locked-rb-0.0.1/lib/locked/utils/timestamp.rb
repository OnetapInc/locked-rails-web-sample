# frozen_string_literal: true

module Locked
  module Utils
    # generates proper timestamp
    class Timestamp
      def self.call
        Time.now.utc.iso8601(3)
      end
    end
  end
end
