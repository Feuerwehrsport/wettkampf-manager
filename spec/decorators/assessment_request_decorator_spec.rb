require 'rails_helper'

RSpec.describe AssessmentRequestDecorator, type: :decorator do
  let(:assessment) { build(:assessment) }
  let(:instance) { described_class.new(assessment_request) }
  let(:assessment_request) do
    build(:assessment_request, assessment_type: assessment_type,
                               group_competitor_order: 2, single_competitor_order: 2, competitor_order: 2,
                               assessment: assessment)
  end
  let(:assessment_type) { :group_competitor }

  describe '#type and #short_type' do
    context 'when group_competitor' do
      let(:assessment_type) { :group_competitor }

      it 'shows long type' do
        expect(instance.type).to eq 'Mannschaftswertung (2)'
        expect(instance.short_type).to eq 'M2'
      end
    end

    context 'when single_competitor' do
      let(:assessment_type) { :single_competitor }

      it 'shows long type' do
        expect(instance.type).to eq 'Einzelstarter (2)'
        expect(instance.short_type).to eq 'E2'
      end
    end

    context 'when out_of_competition' do
      let(:assessment_type) { :out_of_competition }

      it 'shows long type' do
        expect(instance.type).to eq 'Außer der Wertung'
        expect(instance.short_type).to eq 'A'
      end
    end

    context 'when competitor' do
      let(:assessment_type) { :competitor }

      context 'when fire_relay' do
        let(:assessment) { build(:assessment, :fire_relay) }

        it 'shows long type' do
          expect(instance.type).to eq 'A3'
          expect(instance.short_type).to eq 'A3'
        end
      end

      context 'when group_relay' do
        let(:assessment) { build(:assessment, :group_relay) }

        it 'shows long type' do
          expect(instance.type).to eq '3 C-Schlauch'
          expect(instance.short_type).to eq '3<span class="small">(C)</span>'
        end
      end

      context 'when fire_attack' do
        let(:assessment) { build(:assessment, :fire_attack) }

        it 'shows long type' do
          expect(instance.type).to eq '3 Saugkorb'
          expect(instance.short_type).to eq '3<span class="small">(SK)</span>'
        end
      end
    end

    context 'when fallback' do
      let(:assessment_type) { nil }

      it 'shows long type' do
        expect(instance.type).to eq 0
        expect(instance.short_type).to eq 0
      end
    end
  end
end
