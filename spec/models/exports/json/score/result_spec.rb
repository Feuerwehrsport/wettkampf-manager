# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::JSON::Score::Result, type: :model do
  let(:export) { described_class.perform(result.decorate) }
  let(:person1) { create(:person, :generated, :with_team) }
  let(:person2) { create(:person, :generated) }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment, group_assessment: true) }
  let!(:list) { create_score_list(result, person1 => 2200, person2 => nil) }

  describe 'perform' do
    it 'creates export' do
      expect(JSON.parse(export.bytestream, symbolize_names: true)).to eq(
        rows: [
          %w[Platz Vorname Nachname Mannschaft time],
          ['1.', person1.first_name, person1.last_name, 'Mecklenburg-Vorpommern', '22,00'],
          ['2.', person2.first_name, person2.last_name, '', 'D'],
        ],
        name: 'Hakenleitersteigen - Männer',
        gender: 'male',
        discipline: 'hl',
        group_rows: [
          %w[Platz Name Summe],
          ['1.', 'Mecklenburg-Vorpommern', 'D'],
        ],
      )

      expect(export.filename).to eq 'hakenleitersteigen-manner.json'
    end
  end
end
