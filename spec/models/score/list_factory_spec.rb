require 'rails_helper'

RSpec.describe Score::ListFactory, type: :model do
  let(:discipline) { create :climbing_hook_ladder }
  let(:assessment) { create :assessment, discipline: discipline }
  let(:result) { create :score_result, assessment: assessment }
  let(:older_result) { create :score_result, assessment: assessment }
  let(:created_list) { Score::List.last }

  describe "steps" do
    describe "" do
      it "" do
        instance = Score::ListFactory.create!(discipline: discipline, next_step: 'assessments')
        expect(instance.current_step).to eq :assessments
        instance.update!(assessment_ids: [assessment.id], next_step: 'names')

        expect(instance.current_step).to eq :names
        expect(instance.default_name).to eq 'Hakenleitersteigen - Männer - Lauf 1'
        expect(instance.default_shortcut).to eq 'Lauf 1'
        instance.update!(name: 'long name', shortcut: 'short', next_step: 'tracks')

        expect(instance.current_step).to eq :tracks
        expect(instance.default_track_count).to eq 2
        instance.update!(track_count: '3', next_step: 'results')

        expect(instance.current_step).to eq :results

        instance.update!(result_ids: [result.id], next_step: 'generator')
        expect(instance.current_step).to eq :generator
        instance.update!(type: 'Score::ListFactories::Best', next_step: 'generator_params')
        expect(instance.current_step).to eq :generator_params
        instance.update!(before_result: older_result, best_count: 10, next_step: 'finish')
        expect(instance.current_step).to eq :finish

        expect do
          instance.update!(next_step: 'create')
          expect(instance.current_step).to eq :create
        end.to change(Score::List, :count).by(1)

        expect(created_list.name).to eq 'long name'
        expect(created_list.shortcut).to eq 'short'
        expect(created_list.track_count).to eq 3
        expect(created_list.assessments).to eq [assessment]
        expect(created_list.results).to eq [result]
        expect(created_list.entries).to eq []
      end
    end
  end

  describe "#for_run_and_track_for" do
    let(:factory) { Score::ListFactories::Simple.create!(discipline: discipline, assessments: [assessment], name: 'long name', shortcut: 'short', track_count: 2, results: [result]) }
    let(:rows) { [1, 2, 3, 4, 5] }

    it "calls create_list_entry for each run and track" do
      factory.send(:create_list)
      expect(factory).to receive(:create_list_entry).with(1, 1, 1)
      expect(factory).to receive(:create_list_entry).with(2, 1, 2)
      expect(factory).to receive(:create_list_entry).with(3, 2, 1)
      expect(factory).to receive(:create_list_entry).with(4, 2, 2)
      expect(factory).to receive(:create_list_entry).with(5, 3, 1)
      factory.send(:for_run_and_track_for, rows)
    end
  end
end
