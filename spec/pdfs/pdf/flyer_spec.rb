require 'rails_helper'

RSpec.describe PDF::Flyer, type: :model do
  let(:flyer) { described_class.perform }

  describe 'perform' do
    it 'creates pdf' do
      expect(flyer.bytestream).to start_with '%PDF-1.4'
      expect(flyer.bytestream).to end_with "%%EOF\n"
      expect(flyer.bytestream.size).to be_within(63_425).of(2000)
    end
  end
end
