require 'rails_helper'

RSpec.describe Score::ListFactories::Best, type: :model do
  let(:factory) { create(:score_list_factory_best, best_count: 2) }

  describe '#perform_rows' do
    context 'when not enough rows present' do
      before { allow(factory).to receive(:result_rows).and_return([1]) }
      it 'returns all rows' do
        expect(factory.send(:perform_rows)).to have(1).items
      end
    end

    context 'when result is empty' do
      before { allow(factory).to receive(:result_rows).and_return([]) }
      it 'returns an empty array' do
        expect(factory.send(:perform_rows)).to have(0).items
      end
    end

    context 'when more then best count rows are present' do
      before { allow(factory).to receive(:result_rows).and_return([1, 2, 3, 4]) }
      it 'returns first 2 rows' do
        expect(factory.send(:perform_rows)).to have(2).items
      end
      it 'returns in correct order' do
        expect(factory.send(:perform_rows)).to eq [2, 1]
      end
    end

    context 'when last best row and first row outside the range have same value' do
      before { allow(factory).to receive(:result_rows).and_return([1, 2, 2, 4]) }
      it 'returns one row more' do
        expect(factory.send(:perform_rows)).to have(3).items
      end
    end
  end

  describe '#create_list_entry' do
    let(:list) { build_stubbed :score_list }
    let(:result_row) { build :score_result_row }
    let(:assessment_type) { result_row.list_entries.first.assessment_type }
    let(:expected_arguments) do
      { entity: result_row.entity, run: 1, track: 2, assessment_type: assessment_type,
        assessment: result_row.result.assessment }
    end

    before { factory.instance_variable_set(:@list, list) }

    it 'creates list entry with given result row' do
      expect(list.entries).to receive(:create!).with(expected_arguments)
      factory.send(:create_list_entry, result_row, 1, 2)
    end
  end

  describe 'validation' do
    let(:factory) { build(:score_list_factory_best, assessments: [assessment], before_result: result) }

    let(:assessment) { create :assessment }
    let(:other_assessment) { create :assessment }
    let(:list) { create :score_list, assessments: [assessment] }
    let(:result) { create :score_result, assessment: other_assessment }

    before { factory.instance_variable_set(:@list, list) }

    it 'compares assessment from list and result' do
      expect(factory).not_to be_valid
      expect(factory).to have(1).error_on(:before_result)
    end

    context 'with same assessment' do
      let(:result) { create :score_result, assessment: assessment }

      it 'is valid' do
        expect(factory).to be_valid
      end
    end
  end
end
