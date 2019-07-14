# frozen_string_literal: true

module Locked
  # manages configuration variables
  class Configuration
    HOST = ENV['RAILS_ENV'] == 'development' ? 'localhost' : 'locked.jp'
    PORT = ENV['RAILS_ENV'] == 'development' ? 3000 : 443
    URL_PREFIX = 'api/v1/client'
    FAILOVER_STRATEGY = :deny
    REQUEST_TIMEOUT = 1000 # in milliseconds
    FAILOVER_STRATEGIES = %i[allow deny throw].freeze
    WHITELISTED = [
      'User-Agent',
      'Accept-Language',
      'Accept-Encoding',
      'Accept-Charset',
      'Accept',
      'Accept-Datetime',
      'X-Forwarded-For',
      'Forwarded',
      'X-Forwarded',
      'X-Real-IP',
      'REMOTE_ADDR',
      'X-Forwarded-For',
      'CF_CONNECTING_IP'
    ].freeze
    BLACKLISTED = ['HTTP_COOKIE'].freeze

    attr_accessor :host, :port, :request_timeout, :url_prefix
    attr_reader :api_key, :whitelisted, :blacklisted, :failover_strategy

    def initialize
      @formatter = Locked::HeaderFormatter.new
      @request_timeout = REQUEST_TIMEOUT
      self.failover_strategy = FAILOVER_STRATEGY
      self.host = HOST
      self.port = PORT
      self.url_prefix = URL_PREFIX
      self.whitelisted = WHITELISTED
      self.blacklisted = BLACKLISTED
      self.api_key = ''
    end

    def api_key=(value)
      @api_key = ENV.fetch('X_LOCKED_API_KEY', value).to_s
    end

    def whitelisted=(value)
      @whitelisted = (value ? value.map { |header| @formatter.call(header) } : []).freeze
    end

    def blacklisted=(value)
      @blacklisted = (value ? value.map { |header| @formatter.call(header) } : []).freeze
    end

    def valid?
      !api_key.to_s.empty? && !host.to_s.empty? && !port.to_s.empty?
    end

    def failover_strategy=(value)
      @failover_strategy = FAILOVER_STRATEGIES.detect { |strategy| strategy == value.to_sym }
      raise Locked::ConfigurationError, 'unrecognized failover strategy' if @failover_strategy.nil?
    end

    private

    def respond_to_missing?(method_name, _include_private)
      /^(\w+)=$/ =~ method_name
    end

    def method_missing(setting, *_args)
      raise Locked::ConfigurationError, "there is no such a config #{setting}"
    end
  end
end
