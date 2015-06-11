require 'rails_helper'

RSpec.describe Score::ListGenerators::TrackSame, type: :model do
  
  describe '#perform' do
    let(:generator) { described_class.new(best_count: 2) }

  end

  describe "validation" do
    let(:assessment) { build :assessment }
    let(:list) { build :score_list, assessment: assessment }
    let(:before_assessment) { build :assessment }
    let(:before_list) { create :score_list, assessment: before_assessment }
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
