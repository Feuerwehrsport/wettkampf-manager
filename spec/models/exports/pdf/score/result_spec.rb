# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::PDF::Score::Result, type: :model do
  let(:show_pdf) { described_class.perform(result.decorate, only) }
  let(:person1) { create(:person, :generated, team: team) }
  let(:person2) { create(:person, :generated, team: team) }
  let(:team) { nil }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment, group_assessment: true) }
  let!(:list) { create_score_list(result, person1 => 2200, person2 => nil) }
  let(:only) { nil }

  describe 'perform' do
    it 'creates pdf' do
      expect(show_pdf.bytestream).to start_with '%PDF-1.4'
      expect(show_pdf.bytestream).to end_with "%%EOF\n"
      expect(show_pdf.bytestream.size).to be_within(52_575).of(2000)

      expect(show_pdf.filename).to eq 'hakenleitersteigen-manner.pdf'
    end

    context 'when group result present' do
      let(:team) { create(:team) }

      before do
        Competition.one.update!(group_assessment: true, group_score_count: 1)
      end

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(69_795).of(2000)

        expect(show_pdf.filename).to eq 'hakenleitersteigen-manner.pdf'
      end
    end

    context 'when only is group_assessment' do
      let(:only) { :group_assessment }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(50_000).of(2000)

        expect(show_pdf.filename).to eq 'hakenleitersteigen-manner.pdf'
      end
    end

    context 'when only is single_competitors' do
      let(:only) { :single_competitors }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(50_000).of(2000)

        expect(show_pdf.filename).to eq 'hakenleitersteigen-manner.pdf'
      end
    end
  end
end
