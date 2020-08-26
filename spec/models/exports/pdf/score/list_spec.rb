# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::PDF::Score::List, type: :model do
  let(:show_pdf) { described_class.perform(list.decorate, more_columns, double_run) }
  let(:entity1) { create(:person, :generated) }
  let(:entity2) { create(:person, :generated) }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment) }
  let(:list) { create_score_list(result, entity1 => 2200, entity2 => nil) }
  let(:more_columns) { false }
  let(:double_run) { false }

  describe 'perform' do
    it 'creates pdf' do
      expect(show_pdf.bytestream).to start_with '%PDF-1.4'
      expect(show_pdf.bytestream).to end_with "%%EOF\n"
      expect(show_pdf.bytestream.size).to be_within(2000).of(48_822)

      expect(show_pdf.filename).to eq 'hakenleitersteigen-manner-lauf-1.pdf'
    end

    context 'when entity is a team' do
      let(:assessment) { create(:assessment, :fire_attack) }
      let(:entity1) { create(:team, :generated) }
      let(:entity2) { create(:team, :generated) }

      before { list.update!(name: 'Löschangriff - Männer - Lauf 1') }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(2000).of(43_603)

        expect(show_pdf.filename).to eq 'loschangriff-manner-lauf-1.pdf'
      end
    end

    context 'when entity is a team_relay' do
      let(:assessment) { create(:assessment, :fire_relay) }
      let(:entity1) { create(:team_relay, number: 1) }
      let(:entity2) { create(:team_relay, number: 2) }

      before { list.update!(name: 'Feuerwehrstafette - Männer - Lauf 1') }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(2000).of(45_711)

        expect(show_pdf.filename).to eq 'feuerwehrstafette-manner-lauf-1.pdf'
      end
    end

    context 'when more_columns set' do
      let(:more_columns) { true }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(2000).of(50_795)

        expect(show_pdf.filename).to eq 'hakenleitersteigen-manner-lauf-1-kampfrichter.pdf'
      end
    end

    context 'when double_run set' do
      let(:double_run) { true }

      it 'creates pdf' do
        expect(show_pdf.bytestream).to start_with '%PDF-1.4'
        expect(show_pdf.bytestream).to end_with "%%EOF\n"
        expect(show_pdf.bytestream.size).to be_within(2000).of(49_837)

        expect(show_pdf.filename).to eq 'hakenleitersteigen-manner.pdf'
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
        expect(show_pdf.bytestream.size).to be_within(2000).of(43_677)

        expect(show_pdf.filename).to eq 'hakenleitersteigen-manner-lauf-1.pdf'
      end
    end
  end
end
