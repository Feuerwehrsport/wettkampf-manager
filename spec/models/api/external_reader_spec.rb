# frozen_string_literal: true

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
      expect(reader).to receive(:serial_adapter).and_return(StringIO.new(''))
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

  describe '.send_data', vcr: true do
    let(:password) { 'secret' }

    before do
      reader.url = 'http://t530:3000'
      reader.password = password
    end

    it 'sends data to server' do
      expect(terminal).not_to receive(:say)
      expect(reader.send(:send_data, 1234, 'Test-Data')).to eq true
    end

    context 'when password is wrong' do
      let(:password) { 'wrong' }

      it 'catches error and says the message' do
        expect(terminal).to receive(:say).with('Fehler: {"password"=>["ist nicht gültig"]}')
        expect(reader.send(:send_data, 1234, 'Test-Data')).to eq false
      end
    end

    context 'when json is not valid' do
      it 'catches error and says the message' do
        expect(terminal).to receive(:say).with("Fehler: 784: unexpected token at '{foobar}'")
        expect(reader.send(:send_data, 1234, 'Test-Data')).to eq false
      end
    end

    context 'when server is not responding' do
      it 'catches error and says the message' do
        expect(Net::HTTP).to receive(:new).and_raise(Errno::ECONNREFUSED)
        expect(terminal).to receive(:say).with('Fehler: Connection refused')
        expect(reader.send(:send_data, 1234, 'Test-Data')).to eq false
      end
    end

    context 'when server is not responding to slow' do
      it 'catches error and says the message' do
        expect(Net::HTTP).to receive(:new).and_raise(Net::ReadTimeout)
        expect(terminal).to receive(:say).with('Fehler: Net::ReadTimeout')
        expect(reader.send(:send_data, 1234, 'Test-Data')).to eq false
      end
    end
  end
end
