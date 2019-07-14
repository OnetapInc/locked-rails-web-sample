# frozen_string_literal: true

describe Locked::API::Request do
  describe '#call' do
    subject(:call) { described_class.call(command, api_key, headers) }

    let(:http) { instance_double('Net::HTTP') }
    let(:request_build) { instance_double('Locked::API::Request::Build') }
    let(:command) { Locked::Commands::Authenticate.new({}).build(event: '$login.success') }
    let(:headers) { {} }
    let(:api_key) { 'key' }
    let(:expected_headers) { { 'Content-Type' => 'application/json' } }

    before do
      allow(described_class).to receive(:http).and_return(http)
      allow(http).to receive(:request).with(request_build)
      allow(Locked::API::Request::Build).to receive(:call)
        .with(command, expected_headers, api_key)
        .and_return(request_build)
      call
    end

    it do
      expect(Locked::API::Request::Build).to have_received(:call)
        .with(command, expected_headers, api_key)
    end
    it { expect(http).to have_received(:request).with(request_build) }
  end

  describe '#http' do
    subject(:http) { described_class.http }

    context 'when ssl false' do
      before do
        Locked.config.host = 'localhost'
        Locked.config.port = 3002
      end

      after do
        Locked.config.host = Locked::Configuration::HOST
        Locked.config.port = Locked::Configuration::PORT
      end

      it { expect(http).to be_instance_of(Net::HTTP) }
      it { expect(http.address).to eq(Locked.config.host) }
      it { expect(http.port).to eq(Locked.config.port) }
      it { expect(http.use_ssl?).to be false }
      it { expect(http.verify_mode).to be_nil }
    end

    context 'when ssl true' do
      it { expect(http).to be_instance_of(Net::HTTP) }
      it { expect(http.address).to eq(Locked.config.host) }
      it { expect(http.port).to eq(Locked.config.port) }
      it { expect(http.use_ssl?).to be true }
      it { expect(http.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER) }
    end
  end
end
