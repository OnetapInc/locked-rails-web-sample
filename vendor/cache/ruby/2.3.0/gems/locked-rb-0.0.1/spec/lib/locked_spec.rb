# frozen_string_literal: true

describe Locked do
  subject(:locked) { described_class }

  describe 'config' do
    it { expect(Locked.config).to be_kind_of(Locked::Configuration) }
  end

  describe 'api_key setter' do
    let(:value) { 'new_key' }

    before { locked.api_key = value }

    it { expect(Locked.config.api_key).to be_eql(value) }
  end

  describe 'configure' do
    let(:value) { 'new_key' }
    let(:timeout) { 60 }

    shared_examples 'config_setup' do
      it { expect(Locked.config.api_key).to be_eql(value) }
      it { expect(Locked.config.request_timeout).to be_eql(timeout) }
    end

    context 'with block' do
      before do
        Locked.configure do |config|
          config.api_key = value
          config.request_timeout = timeout
        end
      end

      it_behaves_like 'config_setup'
    end

    context 'with options' do
      before { Locked.configure(request_timeout: timeout, api_key: value) }

      it_behaves_like 'config_setup'
    end

    context 'with block and options' do
      before do
        Locked.configure(request_timeout: timeout) do |config|
          config.api_key = value
        end
      end

      it_behaves_like 'config_setup'
    end
  end

  describe 'configure wrongly' do
    let(:value) { 'new_key' }

    it do
      expect do
        Locked.configure do |config|
          config.wrong_config = value
        end
      end.to raise_error(Locked::ConfigurationError)
    end
  end
end
