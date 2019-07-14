# frozen_string_literal: true

module Locked
  class Client
    class << self
      def from_request(request, options = {})
        new(
          to_context(request, options),
          to_options(options)
        )
      end

      def to_context(request, options = {})
        default_context = Locked::Context::Default.new(request, options[:cookies]).call
        Locked::Context::Merger.call(default_context, options[:context])
      end

      def to_options(options = {})
        options[:timestamp] ||= Locked::Utils::Timestamp.call
        warn '[DEPRECATION] use user_traits instead of traits key' if options.key?(:traits)
        options
      end

      def failover_response_or_raise(failover_response, error)
        return failover_response.generate unless Locked.config.failover_strategy == :throw
        raise error
      end
    end

    attr_accessor :context

    def initialize(context, options = {})
      @timestamp = options[:timestamp]
      @context = context
    end

    def authenticate(options = {})
      options = Locked::Utils.deep_symbolize_keys(options || {})

      add_timestamp_if_necessary(options)
      command = Locked::Commands::Authenticate.new(@context).build(options)
      begin
        Locked::API.request(command).merge(failover: false, failover_reason: nil)
      rescue Locked::RequestError, Locked::InternalServerError => error
        self.class.failover_response_or_raise(
          FailoverAuthResponse.new(options[:user_id], reason: error.to_s), error
        )
      end
    end

    def identify(options = {})
      options = Locked::Utils.deep_symbolize_keys(options || {})

      add_timestamp_if_necessary(options)

      command = Locked::Commands::Identify.new(@context).build(options)
      Locked::API.request(command)
    end

    private

    def add_timestamp_if_necessary(options)
      options[:timestamp] ||= @timestamp if @timestamp
    end
  end
end
