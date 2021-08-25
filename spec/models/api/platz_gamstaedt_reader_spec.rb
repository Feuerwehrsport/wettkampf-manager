# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::PlatzGamstaedtReader, type: :model do
  let(:reader) { described_class.new }
  let(:test_data) { File.open(Rails.root.join('spec/fixtures/platz_gamstaedt.bin'), 'rb').read.each_byte }

  describe '.perform' do
    it 'parses bytes' do
      expect(reader).to receive(:send_data).with(622, 'Bahn 1')
      expect(reader).to receive(:send_data).with(1561, 'Bahn 1')
      expect(reader).to receive(:send_data).with(1561, 'Bahn 2')

      test_data.each do |byte|
        reader.send(:evaluate_byte, byte)
      end
    end
  end
end
