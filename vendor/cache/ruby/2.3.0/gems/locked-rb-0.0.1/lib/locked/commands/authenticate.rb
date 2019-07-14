# frozen_string_literal: true

module Locked
  module Commands
    class Authenticate
      def initialize(context)
        @context = context
      end

      def build(options = {})
        Locked::Validators::Present.call(options, %i[event])
        context = Locked::Context::Merger.call(@context, options[:context])
        context = Locked::Context::Sanitizer.call(context)

        Locked::Command.new(
          'authenticate',
          options.merge(context: context),
          :post
        )
      end
    end
  end
end
