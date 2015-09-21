require 'rails_helper'

RSpec.describe Score::ListGenerators::Best, type: :model do
  
  describe '#perform_rows' do
    let(:generator) { described_class.new(best_count: 2) }

    context "not enough rows present" do
      before { allow(generator).to receive(:result_rows).and_return([1]) }
      it "returns all rows" do
        expect(generator.send :perform_rows).to have(1).items
      end
    end

    context "result is empty" do
      before { allow(generator).to receive(:result_rows).and_return([]) }
      it "returns an empty array" do
        expect(generator.send :perform_rows).to have(0).items
      end
    end

    context "more then best count rows are present" do
      before { allow(generator).to receive(:result_rows).and_return([1, 2, 3, 4]) }
      it "returns first 2 rows" do
        expect(generator.send :perform_rows).to have(2).items
      end
      it "returns in correct order" do
        expect(generator.send :perform_rows).to eq [2, 1]
      end
    end

    context "last best row and first row outside the range have same value" do
      before { allow(generator).to receive(:result_rows).and_return([1, 2, 2, 4]) }
      it "returns one row more" do
        expect(generator.send :perform_rows).to have(3).items
      end
    end
  end

  describe "#create_list_entry" do
    let(:list) { build_stubbed :score_list }
    let(:generator) { described_class.new(best_count: 2, list: list) }
    let(:result_row) { build :score_result_row }
    let(:assessment_type) { result_row.list_entries.first.assessment_type }
    let(:expected_arguments) { { entity: result_row.entity, run: 1, track: 2, assessment_type: assessment_type, assessment: result_row.result.assessment } }

    it "creates list entry with given result row" do
      expect(list.entries).to receive(:create!).with(expected_arguments)
      generator.send(:create_list_entry, result_row, 1, 2)
    end
  end

  describe "validation" do
    let(:assessment) { create :assessment }
    let(:other_assessment) { create :assessment }
    let(:list) { create :score_list, assessments: [assessment] }
    let(:result) { create :score_result, assessment: other_assessment }
    let(:generator) { described_class.new(best_count: 2, list: list, result: result.id) }

    it "compares assessment from list and result" do
      expect(generator.valid?).to be_falsey
      expect(generator).to have(1).error_on(:result)
    end

    context "with same assessment" do
      let(:result) { create :score_result, assessment: assessment }
      it "is valid" do
        expect(generator.valid?).to be_truthy
      end
    end
  end
end
