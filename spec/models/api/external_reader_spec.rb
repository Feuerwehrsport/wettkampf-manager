require 'rails_helper'

RSpec.describe API::ExternalReader, type: :model do
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  let(:terminal) { HighLine.new(input, output) }
  let(:reader) { API::TeamComputerReader.new }
  let(:serial) { StringIO.new('blub') }

  before do
    allow(reader).to receive(:cli).and_return(terminal)
  end

  describe '.perform' do
    it 'loops' do
      expect(reader).to receive(:sleep).with(0.3).and_raise(RubySerial::Error.new(:blub))
      expect(reader).to receive(:serial_adapter).and_return(serial)
      expect(reader).to receive(:log_send_error).with('Schnittstelle: blub')
      reader.perform
    end
  end

  describe '.check' do
    it 'sends checks' do
      expect(reader).to receive(:send_data).with(0, 'System-Check')
      reader.check
    end
  end

  describe '.log_raw' do
    it 'logs' do
      expect(Rails.logger).to receive(:info).with('line')
      expect(terminal).to receive(:say).with('"line"')
      reader.send(:log_raw, 'line')
    end
  end

  describe '.log_send_error' do
    it 'logs' do
      expect(terminal).to receive(:say).with('Fehler: line')
      reader.send(:log_send_error, 'line')
    end
  end
end
