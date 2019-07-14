# frozen_string_literal: true

describe Locked::API do
  subject(:request) { described_class.request(command) }

  let(:command) { Locked::Commands::Authenticate.new({}).build(event: '$login.success') }

  context 'when request timeouts' do
    before { stub_request(:any, /locked.jp/).to_timeout }

    it do
      expect do
        request
      end.to raise_error(Locked::RequestError)
    end
  end

  context 'when non-OK response code' do
    before { stub_request(:any, /locked.jp/).to_return(status: 400) }

    it do
      expect do
        request
      end.to raise_error(Locked::BadRequestError)
    end
  end

  context 'when no api_key' do
    before { allow(Locked.config).to receive(:api_key).and_return('') }

    it do
      expect do
        request
      end.to raise_error(Locked::ConfigurationError)
    end
  end
end
