# frozen_string_literal: true

describe Locked::API::Request::Build do
  subject(:call) { described_class.call(command, headers, api_key) }

  let(:headers) { { 'SAMPLE-HEADER' => '1' } }
  let(:api_key) { 'key' }

  describe 'call' do
    # context 'when get' do
    #   let(:command) { Locked::Commands::Review.build(review_id) }
    #   let(:review_id) { SecureRandom.uuid }
    #
    #   it { expect(call.body).to be_nil }
    #   it { expect(call.method).to eql('GET') }
    #   it { expect(call.path).to eql("/api/v1/client#{command.path}") }
    #   it { expect(call.to_hash).to have_key('authorization') }
    #   it { expect(call.to_hash).to have_key('sample-header') }
    #   it { expect(call.to_hash['sample-header']).to eql(['1']) }
    # end

    context 'when post' do
      let(:time) { Time.now.utc.iso8601(3) }
      let(:command) { Locked::Commands::Authenticate.new({}).build(event: '$login.success', name: "test") }
      let(:expected_body) do
        {
          event: '$login.success',
          name: "test",
          # context: {},
        }
      end

      before { allow(Locked::Utils::Timestamp).to receive(:call).and_return(time) }

      it { expect(call.body).to be_eql(expected_body.to_json) }
      it { expect(call.method).to eql('POST') }
      it { expect(call.path).to eql("/api/v1/client/#{command.path}") }
      it { expect(call.to_hash).to have_key('sample-header') }
      it { expect(call.to_hash['sample-header']).to eql(['1']) }
    end
  end
end
