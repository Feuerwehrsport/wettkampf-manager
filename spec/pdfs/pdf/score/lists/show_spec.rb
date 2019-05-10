require 'rails_helper'

RSpec.describe PDF::Score::Lists::Show, type: :model do
  let(:show_pdf) { described_class.perform(list.decorate, more_columns, double_run) }
  let(:person1) { create(:person, :generated) }
  let(:person2) { create(:person, :generated) }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment) }
  let(:list) { create_score_list(result, person1 => 2200, person2 => nil) }
  let(:more_columns) { false }
  let(:double_run) { false }

  describe 'perform' do
    it 'creates pdf' do
      expect(show_pdf.bytestream).to start_with '%PDF-1.4'
      expect(show_pdf.bytestream).to end_with "%%EOF\n"
      expect(show_pdf.bytestream.size).to be_within(48_000).of(2000)
    end

    context 'when more_columns set' do
      let(:more_columns) { true }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(50_000).of(2000)
      end
    end

    context 'when double_run set' do
      let(:double_run) { true }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(49_837).of(2000)
      end
    end
    context 'when group discipline' do
      let(:team1) { create(:team, :generated) }
      let(:team2) { create(:team, :generated) }
      let(:assessment) { create(:assessment, :fire_attack) }
      let(:list) { create_score_list(result, team1 => 2200, team2 => nil) }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(48_661).of(2000)
      end
    end
  end
end
