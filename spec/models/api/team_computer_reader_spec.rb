require 'rails_helper'

RSpec.describe API::TeamComputerReader, type: :model do
  let(:reader) { described_class.new }

  describe '.evaluate_output' do
    it 'split lines' do
      expect(reader).to receive(:log_raw).with("invalid: aa#0:08,000|0:09,343*\r\n")
      reader.send(:evaluate_output, 'aa#0:08,000|')
      reader.send(:evaluate_output, "0:09,343*\r\n")

      expect(reader).to receive(:log_raw).with("valid:   #0:08,000|0:10,662*\r\n")
      expect(reader).to receive(:send_data).with(800, 'Bahn 1')
      expect(reader).to receive(:send_data).with(1066, 'Bahn 2')
      reader.send(:evaluate_output, "#0:08,000|0:10,662*\r\n")

      expect(reader).to receive(:log_raw).with("valid:   #11:68,123|0:10,668*\r\n")
      expect(reader).to receive(:send_data).with(11 * 6000 + 6812, 'Bahn 1')
      expect(reader).to receive(:send_data).with(1066, 'Bahn 2')
      reader.send(:evaluate_output, "#11:68,123|0:10,668*\r\n")
    end
  end
end
