# frozen_string_literal: true

module Locked
  module Commands
    class Identify
      def initialize(context)
        @context = context
      end

      def build(options = {})
        Locked::Validators::NotSupported.call(options, %i[properties])
        context = Locked::Context::Merger.call(@context, options[:context])
        context = Locked::Context::Sanitizer.call(context)

        Locked::Command.new(
          'identify',
          options.merge(context: context),
          :post
        )
      end
    end
  end
end
