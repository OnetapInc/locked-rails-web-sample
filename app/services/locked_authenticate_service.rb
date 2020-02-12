# frozen_string_literal: true

require 'net/http'

class LockedAuthenticateService
  LOCKED_ROOT = Rails.env.development? ? 'http://app:3000' : 'https://locked.jp'
  LOCKED_API_PATH = '/api/v1/client/'

  def initialize(api_key, params, path = 'authenticate')
    @api_key = api_key
    @uri = URI.parse(LOCKED_ROOT + LOCKED_API_PATH + path)
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @params = params
  end

  def call
    @http.use_ssl = @uri.scheme === 'https'
    req = Net::HTTP::Post.new(@uri.path)
    req['Content-Type'] = 'application/json'
    req['X-LOCKED-API-KEY'] = @api_key
    req.body = @params.to_json
    response = @http.request(req)
    JSON.parse(response.body).deep_symbolize_keys
  end

  private
end
