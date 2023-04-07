# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::FullDump, type: :model do
  let(:dump) { described_class.new }

  let!(:score_competition_result) { create(:score_competition_result) }
  let(:person1) { create(:person, :generated) }
  let(:person2) { create(:person, :generated) }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment) }
  let!(:list) { create_score_list(result, person1 => 2200, person2 => nil) }

  let(:created_files) do
    [
      'startliste-hakenleitersteigen-manner-lauf-1.xlsx',
      'startliste-hakenleitersteigen-manner-lauf-1.pdf',
      'startliste-hakenleitersteigen-manner-lauf-1.json',
      'ergebnis-hakenleitersteigen-manner.xlsx',
      'ergebnis-hakenleitersteigen-manner.pdf',
      'ergebnis-hakenleitersteigen-manner.json',
      'gesamtwertungen.xlsx',
      'gesamtwertungen.pdf',
      'gesamtwertungen.json',
      'wettkaempfer.xlsx',
      'wettkaempfer.pdf',
      'wettkaempfer.json',
      'mannschaften.xlsx',
      'mannschaften.pdf',
      'mannschaften.json',
    ]
  end

  describe 'new' do
    it 'creates files' do
      expect(dump.send(:files).map(&:name)).to eq created_files

      expect(FileUtils).to receive(:mkdir_p).with('/path')
      created_files.each do |file|
        expect(File).to receive(:open).with("/path/#{file}", 'wb')
      end
      dump.to_path('/path')

      hash = dump.to_export_hash
      expect(hash.except(:files)).to eq(name: 'Wettkampf', date: Date.current.to_s, place: 'Bargeshagen')
      expect(hash[:files].count).to eq(created_files.count)
      expect(hash[:files].first.except(:base64_data)).to eq(
        name: created_files.first, mimetype: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      )

      expect(JSON.parse(Zlib::Inflate.inflate(dump.to_export_data), symbolize_names: true)).to eq(hash)
    end
  end
end
