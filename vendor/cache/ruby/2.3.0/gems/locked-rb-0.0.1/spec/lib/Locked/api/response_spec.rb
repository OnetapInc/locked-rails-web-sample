# frozen_string_literal: true

describe Locked::API::Response do
  describe '#call' do
    subject(:call) { described_class.call(response) }

    context 'when success' do
      let(:response) { OpenStruct.new(body: '{"user":1}', code: 200) }

      it { expect(call).to eql(user: 1) }
    end

    context 'when response empty' do
      let(:response) { OpenStruct.new(body: '', code: 200) }

      it { expect(call).to eql({}) }
    end

    context 'when response nil' do
      let(:response) { OpenStruct.new(code: 200) }

      it { expect(call).to eql({}) }
    end

    context 'when json is malformed' do
      let(:response) { OpenStruct.new(body: '{a', code: 200) }

      it { expect { call }.to raise_error(Locked::ApiError) }
    end
  end

  describe '#verify!' do
    subject(:verify!) { described_class.verify!(response) }

    context 'without error when response is 2xx' do
      let(:response) { OpenStruct.new(code: 200) }

      it { expect { verify! }.not_to raise_error }
    end

    shared_examples 'response_failed' do |code, error|
      let(:response) { OpenStruct.new(code: code) }

      it "fail when response is #{code}" do
        expect { verify! }.to raise_error(error)
      end
    end

    it_behaves_like 'response_failed', '400', Locked::BadRequestError
    it_behaves_like 'response_failed', '401', Locked::UnauthorizedError
    it_behaves_like 'response_failed', '403', Locked::ForbiddenError
    it_behaves_like 'response_failed', '404', Locked::NotFoundError
    it_behaves_like 'response_failed', '419', Locked::UserUnauthorizedError
    it_behaves_like 'response_failed', '422', Locked::InvalidParametersError
    it_behaves_like 'response_failed', '499', Locked::ApiError
    it_behaves_like 'response_failed', '500', Locked::InternalServerError
  end
end
