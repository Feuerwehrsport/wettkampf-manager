require 'rails_helper'

RSpec.describe Exports::XLSX::Score::CompetitionResults, type: :model do
  let(:index_xlsx) { described_class.perform([score_competition_result]) }
  let(:score_competition_result) { create(:score_competition_result).decorate }

  describe 'perform' do
    it 'creates xlsx' do
      expect(index_xlsx.bytestream).to start_with "PK\u0003"
      expect(index_xlsx.bytestream).to end_with "\u0000\u0000"
      expect(index_xlsx.bytestream.size).to be_within(100).of(3459)
    end
  end
end
