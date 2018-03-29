require 'rails_helper'

RSpec.describe Score::ListFactories::TrackChange, type: :model do
  subject { build :score_list_factory_track_change, before_list: before_list, assessments: [assessment] }

  describe 'validation' do
    let(:assessment) { create :assessment }
    let(:before_assessment) { create :assessment }
    let(:before_result) { create :score_result, assessment: before_assessment }
    let(:before_list) { create :score_list, assessments: [before_assessment], results: [before_result] }

    it 'compares assessment from list and before_list' do
      expect(subject).not_to be_valid
      expect(subject).to have(1).error_on(:before_list)
    end

    context 'with same assessment' do
      let(:before_assessment) { assessment }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end
end
