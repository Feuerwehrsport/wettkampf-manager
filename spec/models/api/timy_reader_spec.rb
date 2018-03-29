require 'rails_helper'

RSpec.describe API::TimyReader, type: :model do
  let(:reader) { described_class.new }

  describe '.evaluate_output' do
    it 'split lines' do
      expect(reader).to receive(:log_raw).with("invalid: yNNNNxCCCxHH:MM:SS.zhtqxGGRRRR\r")
      reader.send(:evaluate_output, "yNNNNxCCCxHH:MM:SS.zhtqxGGRRRR\r")

      expect(reader).to receive(:log_raw).with("invalid:  0001 c0  15:43:49,8863 00    \r")
      reader.send(:evaluate_output, ' 0001 c0  15:43:')
      reader.send(:evaluate_output, "49,8863 00    \r")

      expect(reader).to receive(:log_raw).with("valid:    0011 c1M 00:00:01.83   01\r")
      expect(reader).to receive(:send_data).with(183, 'Bahn 1')
      reader.send(:evaluate_output, " 0011 c1M 00:00:01.83   01\r")

      expect(reader).to receive(:log_raw).with("valid:    0011 c2  01:22:21.83   01\r")
      expect(reader).to receive(:send_data).with(82 * 6000 + 2183, 'Bahn 2')
      reader.send(:evaluate_output, " 0011 c2  01:22:21.83   01\r")
    end
  end
end
