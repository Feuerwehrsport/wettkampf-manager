require 'rails_helper'

RSpec.describe API::LandesanlageMVReader, type: :model do
  let(:reader) { described_class.new }
  
  describe '.evaluate_output' do
    it 'split lines' do
      expect(reader).to receive(:log_raw).with("invalid: aa#0:08,000|0:09,343*\r\n")
      reader.send(:evaluate_output, "aa#0:08,000|")
      reader.send(:evaluate_output, "0:09,343*\r\n")

      expect(reader).to receive(:log_raw).with("valid:   *0:00,015:55,667:99,55#\r\n")
      expect(reader).to receive(:send_data).with(1, 'Bahn 1')
      expect(reader).to receive(:send_data).with(5*6000 + 5566, 'Bahn 2')
      expect(reader).to receive(:send_data).with(7*6000 + 9955, 'Bahn 3')
      reader.send(:evaluate_output, "*0:00,015:55,667:99,55#\r\n")

      expect(reader).to receive(:log_raw).with("valid:   *9:99,990:05,660:99,55#\r\n")
      expect(reader).to receive(:send_data).with(9*6000 + 9999, 'Bahn 1')
      expect(reader).to receive(:send_data).with(566, 'Bahn 2')
      expect(reader).to receive(:send_data).with(9955, 'Bahn 3')
      reader.send(:evaluate_output, "*9:99,990:05,660:99,55#\r\n")

      expect(reader).to receive(:log_raw).with("valid:   *-:--,--0:05,660:99,55#\r\n")
      expect(reader).to receive(:send_data).with(9*6000 + 9999, 'Bahn 1')
      expect(reader).to receive(:send_data).with(566, 'Bahn 2')
      expect(reader).to receive(:send_data).with(9955, 'Bahn 3')
      reader.send(:evaluate_output, "*-:--,--0:05,660:99,55#\r\n")
    end
  end
end