require 'rails_helper'

RSpec.describe Exports::PDF::Score::CompetitionResults, type: :model do
  let(:index_pdf) { described_class.perform([score_competition_result]) }
  let(:score_competition_result) { create(:score_competition_result).decorate }

  describe 'perform' do
    it 'creates pdf' do
      expect(index_pdf.bytestream).to start_with '%PDF-1.3'
      expect(index_pdf.bytestream).to end_with "%%EOF\n"
      expect(index_pdf.bytestream.size).to be_within(40_308).of(2000)

      expect(index_pdf.filename).to eq 'gesamtwertungen.pdf'
    end
  end
end
