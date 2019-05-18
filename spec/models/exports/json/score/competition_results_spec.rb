require 'rails_helper'

RSpec.describe Exports::JSON::Score::CompetitionResults, type: :model do
  let(:export) { described_class.perform([score_competition_result]) }
  let(:score_competition_result) { create(:score_competition_result).decorate }

  describe 'perform' do
    it 'creates xlsx' do
      expect(export.bytestream).to eq({
        results: [{ name: 'Wettkampf', rows: [%w[Platz Mannschaft Punkte]] }],
      }.to_json)
    end
  end
end
