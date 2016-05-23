require 'rails_helper'

RSpec.describe Score::ListFactories::TrackSame, type: :model do
  subject { build :score_list_factory_track_same, before_list: before_list, assessments: [assessment] }

  describe "validation" do
    let(:assessment) { create :assessment }
    let(:list) { build :score_list, assessments: [assessment] }
    let(:before_assessment) { create :assessment }
    let(:before_result) { create :score_result, assessment: before_assessment }
    let(:before_list) { create :score_list, assessments: [before_assessment], results: [before_result] }

    it "compares assessment from list and before_list" do
      expect(subject.valid?).to be_falsey
      expect(subject).to have(1).error_on(:before_list)
    end

    context "with same assessment" do
      let(:before_assessment) { assessment }
      it "is valid" do
        expect(subject.valid?).to be_truthy
      end
    end
  end
end
