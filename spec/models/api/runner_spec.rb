require 'rails_helper'

RSpec.describe API::Runner, type: :model do
  let(:runner) { described_class.new }
  let(:input) { IO.new(IO.sysopen(Tempfile.new.path, 'a+')) }
  let(:output) { IO.new(IO.sysopen(Tempfile.new.path, 'a+')) }
  let(:terminal) { HighLine.new(input, output) }

  describe 'workflow' do
    before do
      allow_any_instance_of(described_class).to receive(:cli).and_return(terminal)
      allow_any_instance_of(described_class).to receive(:config).and_return({})
    end

    it 'asks questions' do
      expect(File).to receive(:write).with(Rails.root.join('api_runner.config'), {
        klass_select: 'Computer vom Team-MV', serial_connection: '/dev/ttyUSB0',
        sender_select: 'Hakenleitersteigen', url: 'http://localhost:3000'
      }.to_json)
      expect(API::TeamComputerReader).to receive(:start_with_check).with(
        url: 'http://localhost:3000', password: 'pass', serial_connection: '/dev/ttyUSB0', cli: terminal,
        sender: 'Hakenleitersteigen'
      )

      input << "2\n" # MV-Computer
      input << "\n" # Enter (default)
      input << "1\n" # HL
      input << "\n" # Enter (default)
      input << "pass\n" # Enter (default)
      input.rewind
      runner

      output.rewind
      expect(output.read.lines.map(&:strip).join("\n")).to eq <<~CLI


        1. Timy von Alge-Timing
        2. Computer vom Team-MV
        3. Landesanlage MV
        Bitte das angeschlossene Gerät angeben:
        Angeschlossene Schnittstelle? |/dev/ttyUSB0|
        1. Hakenleitersteigen
        2. Löschangriff Nass
        3. 4x100m Feuerwehrstafette
        4. 100m Hindernisbahn
        5. Gruppenstafette
        6. Anderes
        Zeiten der Disziplin:
        URL zu Wettkampf-Manager? |http://localhost:3000|
        Admin/API-Passwort für Wettkampf-Manager:  ****
      CLI
    end
  end
end
