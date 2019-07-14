# frozen_string_literal: true

describe Locked::Review do
  # before do
  #   stub_request(:any, /locked.jp/).with(
  #     basic_auth: ['', 'key']
  #   ).to_return(status: 200, body: '{}', headers: {})
  # end
  #
  # describe '#retrieve' do
  #   subject(:retrieve) { described_class.retrieve(review_id) }
  #
  #   let(:review_id) { '1234' }
  #
  #   before { retrieve }
  #
  #   it { assert_requested :get, "https://locked.jp/api/v1/client/reviews/#{review_id}", times: 1 }
  # end
end
