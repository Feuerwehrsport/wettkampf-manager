require 'rails_helper'

RSpec.describe Score::ListGenerators::TrackSame, type: :model do
  
  describe '#perform' do
    let(:generator) { described_class.new(best_count: 2) }

  end

  describe "validation" do
    let(:assessment) { create :assessment }
    let(:list) { build :score_list, assessments: [assessment] }
    let(:before_assessment) { create :assessment }
    let(:before_result) { create :score_result, assessment: before_assessment }
    let(:before_list) { create :score_list, assessments: [before_assessment], results: [before_result] }
    let(:generator) { described_class.new(best_count: 2, list: list, before_list: before_list.id) }

    it "compares assessment from list and before_list" do
      expect(generator.valid?).to be_falsey
      expect(generator).to have(1).error_on(:before_list)
    end

    context "with same assessment" do
      let(:before_assessment) { assessment }
      it "is valid" do
        expect(generator.valid?).to be_truthy
      end
    end
  end
end
