require 'rails_helper'

RSpec.describe Exports::PDF::Score::Result, type: :model do
  let(:show_pdf) { described_class.perform(result.decorate, only) }
  let(:person1) { create(:person, :generated) }
  let(:person2) { create(:person, :generated) }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment, group_assessment: true) }
  let!(:list) { create_score_list(result, person1 => 2200, person2 => nil) }
  let(:only) { nil }

  describe 'perform' do
    it 'creates pdf' do
      expect(show_pdf.bytestream).to start_with '%PDF-1.4'
      expect(show_pdf.bytestream).to end_with "%%EOF\n"
      expect(show_pdf.bytestream.size).to be_within(52_575).of(2000)
    end

    context 'when only is group_assessment' do
      let(:only) { :group_assessment }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(50_000).of(2000)
      end
    end

    context 'when only is single_competitors' do
      let(:only) { :single_competitors }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(50_000).of(2000)
      end
    end
  end
end
