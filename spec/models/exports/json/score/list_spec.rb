require 'rails_helper'

RSpec.describe Exports::JSON::Score::List, type: :model do
  let(:export) { described_class.perform(list.decorate) }
  let(:person1) { create(:person, :generated, :with_team) }
  let(:person2) { create(:person, :generated) }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment) }
  let(:list) { create_score_list(result, person1 => 2200, person2 => nil) }

  describe 'perform' do
    it 'creates export' do
      expect(export.bytestream).to eq({
        rows: [
          %w[Lauf Bahn Nachname Vorname Mannschaft Zeit],
          [1, 1, person1.last_name, person1.first_name, 'Team MV', '22,00'],
          ['', 2, person2.last_name, person2.first_name, '', 'D'],
        ],
      }.to_json)

      expect(export.filename).to eq 'hakenleitersteigen-manner-lauf-1.json'
    end
  end
end
