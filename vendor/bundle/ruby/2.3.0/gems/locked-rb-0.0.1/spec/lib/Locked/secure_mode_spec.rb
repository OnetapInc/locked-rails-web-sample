# frozen_string_literal: true

describe Locked::SecureMode do
  it 'has signature' do
    expect(described_class.signature('test')).to eql(
      '02afb56304902c656fcb737cdd03de6205bb6d401da2812efd9b2d36a08af159'
    )
  end
end
