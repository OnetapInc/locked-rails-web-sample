# frozen_string_literal: true

module Locked
  module Context
    class Merger
      class << self
        def call(initial_context, request_context)
          main_context = Locked::Utils::Cloner.call(initial_context)
          Locked::Utils::Merger.call(main_context, request_context || {})
        end
      end
    end
  end
end
