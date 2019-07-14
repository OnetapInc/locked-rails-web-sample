# frozen_string_literal: true

module Locked
  module Validators
    class NotSupported
      class << self
        def call(options, keys)
          keys.each do |key|
            next unless options.key?(key)
            raise Locked::InvalidParametersError, "#{key} is/are not supported"
          end
        end
      end
    end
  end
end
