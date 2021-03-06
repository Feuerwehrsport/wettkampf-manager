# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::XLSX::Score::Result, type: :model do
  let(:show_xlsx) { described_class.perform(result.decorate) }
  let(:person1) { create(:person, :generated, team: team) }
  let(:person2) { create(:person, :generated, team: team) }
  let(:team) { nil }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment, group_assessment: true) }
  let!(:list) { create_score_list(result, person1 => 2200, person2 => nil) }

  describe 'perform' do
    it 'creates xlsx' do
      expect(show_xlsx.bytestream).to start_with "PK\u0003"
      expect(show_xlsx.bytestream).to end_with "\u0000\u0000"
      expect(show_xlsx.bytestream.size).to be_within(100).of(4623)

      expect(show_xlsx.filename).to eq 'hakenleitersteigen-manner.xlsx'
    end

    context 'when group result present' do
      let(:team) { create(:team) }

      before do
        Competition.one.update!(group_assessment: true, group_score_count: 1)
      end

      it 'creates pdf' do
        expect(show_xlsx.bytestream).to start_with "PK\u0003"
        expect(show_xlsx.bytestream).to end_with "\u0000\u0000"
        expect(show_xlsx.bytestream.size).to be_within(100).of(4832)

        expect(show_xlsx.filename).to eq 'hakenleitersteigen-manner.xlsx'
      end
    end
  end
end
