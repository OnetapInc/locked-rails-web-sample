# frozen_string_literal: true

module Locked
  module Utils
    class Cloner
      def self.call(object)
        Marshal.load(Marshal.dump(object))
      end
    end
  end
end
