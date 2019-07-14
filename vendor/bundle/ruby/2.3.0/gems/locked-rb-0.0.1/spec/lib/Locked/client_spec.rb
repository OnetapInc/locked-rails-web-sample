# frozen_string_literal: true

describe Locked::Client do
  let(:ip) { '1.2.3.4' }
  let(:cookie_id) { 'abcd' }
  let(:ua) { 'Chrome' }
  let(:env) do
    Rack::MockRequest.env_for(
      '/',
      'HTTP_USER_AGENT' => ua,
      'HTTP_X_FORWARDED_FOR' => ip,
      'HTTP_COOKIE' => "__cid=#{cookie_id};other=efgh",
      'X-LOCKED-API-KEY' => 'key'
    )
  end
  let(:request) { Rack::Request.new(env) }
  let(:client) { described_class.from_request(request) }
  let(:request_to_context) { described_class.to_context(request) }
  let(:client_with_user_timestamp) do
    described_class.new(request_to_context, timestamp: time_user)
  end
  let(:client_with_no_timestamp) { described_class.new(request_to_context) }

  let(:headers) { { 'X-Forwarded-For' => ip.to_s, 'User-Agent' => ua } }
  let(:context) do
    {
      client_id: 'abcd',
      active: true,
      origin: 'web',
      user_agent: ua,
      headers: { 'X-Forwarded-For': ip.to_s, 'User-Agent': ua },
      ip: ip,
      library: { name: 'locked-rb', version: '0.0.1' }
    }
  end

  let(:time_now) { Time.now }
  let(:time_auto) { time_now.utc.iso8601(3) }
  let(:time_user) { (Time.now - 10_000).utc.iso8601(3) }
  let(:response_body) { {}.to_json }

  before do
    Timecop.freeze(time_now)
    stub_const('Locked::VERSION', '0.0.1')
    stub_request(:any, /locked.jp/).to_return(status: 200, body: response_body, headers: {})
  end

  after { Timecop.return }

  describe 'parses the request' do
    before do
      allow(Locked::API).to receive(:request).and_call_original
    end

    it do
      client.authenticate(event: '$login.success', user_id: '1234')
      expect(Locked::API).to have_received(:request)
    end
  end

  describe 'to_context' do
    it do
      expect(described_class.to_context(request)).to eql(context)
    end
  end

  describe 'to_options' do
    let(:options) { { user_id: '1234', user_traits: { name: 'Jo' } } }
    let(:result) { { user_id: '1234', user_traits: { name: 'Jo' }, timestamp: time_auto } }

    it do
      expect(described_class.to_options(options)).to eql(result)
    end
  end

  # describe 'identify' do
  #   let(:request_body) do
  #     { user_id: '1234', timestamp: time_auto,
  #       sent_at: time_auto, context: context, user_traits: { name: 'Jo' } }
  #   end
  #
  #   before { client.identify(options) }
  #
  #   context 'when used with symbol keys' do
  #     let(:options) { { user_id: '1234', user_traits: { name: 'Jo' } } }
  #
  #     it do
  #       assert_requested :post, 'https://locked.jp/api/v1/client/identify', times: 1 do |req|
  #         JSON.parse(req.body) == JSON.parse(request_body.to_json)
  #       end
  #     end
  #
  #     context 'when passed timestamp in options and no defined timestamp' do
  #       let(:client) { client_with_no_timestamp }
  #       let(:options) { { user_id: '1234', user_traits: { name: 'Jo' }, timestamp: time_user } }
  #       let(:request_body) do
  #         { user_id: '1234', user_traits: { name: 'Jo' }, context: context,
  #           timestamp: time_user, sent_at: time_auto }
  #       end
  #
  #       it do
  #         assert_requested :post, 'https://locked.jp/api/v1/client/identify', times: 1 do |req|
  #           JSON.parse(req.body) == JSON.parse(request_body.to_json)
  #         end
  #       end
  #     end
  #
  #     context 'with client initialized with timestamp' do
  #       let(:client) { client_with_user_timestamp }
  #       let(:request_body) do
  #         { user_id: '1234', timestamp: time_user, sent_at: time_auto,
  #           context: context, user_traits: { name: 'Jo' } }
  #       end
  #
  #       it do
  #         assert_requested :post, 'https://locked.jp/api/v1/client/identify', times: 1 do |req|
  #           JSON.parse(req.body) == JSON.parse(request_body.to_json)
  #         end
  #       end
  #     end
  #   end
  #
  #   context 'when used with string keys' do
  #     let(:options) { { 'user_id' => '1234', 'user_traits' => { 'name' => 'Jo' } } }
  #
  #     it do
  #       assert_requested :post, 'https://locked.jp/api/v1/client/identify', times: 1 do |req|
  #         JSON.parse(req.body) == JSON.parse(request_body.to_json)
  #       end
  #     end
  #   end
  # end

  describe 'authenticate' do
    let(:options) { { event: '$login.success', user_id: '1234' } }
    let(:request_response) { client.authenticate(options) }
    let(:request_body) do
      { event: '$login.success', user_id: '1234', timestamp: time_auto }
    end

    context 'when used with symbol keys' do
      before { request_response }

      it do
        assert_requested :post, 'https://locked.jp/api/v1/client/authenticate', times: 1 do |req|
          JSON.parse(req.body) == JSON.parse(request_body.to_json)
        end
      end

      context 'when passed timestamp in options and no defined timestamp' do
        let(:client) { client_with_no_timestamp }
        let(:options) { { event: '$login.success', user_id: '1234', timestamp: time_user } }
        let(:request_body) do
          { event: '$login.success', user_id: '1234', timestamp: time_user }
        end

        it do
          assert_requested :post, 'https://locked.jp/api/v1/client/authenticate', times: 1 do |req|
            JSON.parse(req.body) == JSON.parse(request_body.to_json)
          end
        end
      end

      context 'with client initialized with timestamp' do
        let(:client) { client_with_user_timestamp }
        let(:request_body) do
          { event: '$login.success', user_id: '1234', timestamp: time_user }
        end

        it do
          assert_requested :post, 'https://locked.jp/api/v1/client/authenticate', times: 1 do |req|
            JSON.parse(req.body) == JSON.parse(request_body.to_json)
          end
        end
      end
    end

    context 'when used with string keys' do
      let(:options) { { 'event' => '$login.success', 'user_id' => '1234' } }

      before { request_response }

      it do
        assert_requested :post, 'https://locked.jp/api/v1/client/authenticate', times: 1 do |req|
          JSON.parse(req.body) == JSON.parse(request_body.to_json)
        end
      end
    end

    context 'when request with fail' do
      before { allow(Locked::API).to receive(:request).and_raise(Locked::RequestError.new(Timeout::Error)) }

      context 'with request error and throw strategy' do
        before { allow(Locked.config).to receive(:failover_strategy).and_return(:throw) }

        it { expect { request_response }.to raise_error(Locked::RequestError) }
      end

      context 'with request error and not throw on eg deny strategy' do
        it { assert_not_requested :post, 'https://locked.jp/api/v1/client/authenticate' }
        it { expect(request_response[:data][:action]).to be_eql('deny') }
        it { expect(request_response[:data][:user_id]).to be_eql('1234') }
        it { expect(request_response[:failover]).to be true }
        it { expect(request_response[:failover_reason]).to be_eql('Locked::RequestError') }
      end
    end

    context 'when request is internal server error' do
      before { allow(Locked::API).to receive(:request).and_raise(Locked::InternalServerError) }

      describe 'throw strategy' do
        before { allow(Locked.config).to receive(:failover_strategy).and_return(:throw) }

        it { expect { request_response }.to raise_error(Locked::InternalServerError) }
      end

      context 'not throw on eg deny strategy' do
        it { assert_not_requested :post, 'https://locked.jp/api/v1/client/authenticate' }
        it { expect(request_response[:data][:action]).to be_eql('deny') }
        it { expect(request_response[:data][:user_id]).to be_eql('1234') }
        it { expect(request_response[:failover]).to be true }
        it { expect(request_response[:failover_reason]).to be_eql('Locked::InternalServerError') }
      end
    end
  end
end
