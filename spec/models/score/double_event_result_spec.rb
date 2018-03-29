require 'rails_helper'

RSpec.describe Score::DoubleEventResult, type: :model do
  subject { Score::DoubleEventResult.create!(assessment: zk_assessment) }

  let(:hl_assessment) { create(:assessment, discipline: create(:climbing_hook_ladder), gender: gender) }
  let(:hl_result) { create :score_result, assessment: hl_assessment, double_event_result: subject }
  let(:hb_assessment) { create(:assessment, discipline: create(:obstacle_course), gender: gender) }
  let(:hb_result) { create :score_result, assessment: hb_assessment, double_event_result: subject }
  let(:zk_assessment) { create(:assessment, discipline: create(:double_event), gender: gender) }

  describe '.rows' do
    let(:person1) { create :person, :generated, gender: gender }
    let(:person2) { create :person, :generated, gender: gender }
    let(:person3) { create :person, :generated, gender: gender }
    let(:person4) { create :person, :generated, gender: gender }

    context 'entries given' do
      let!(:list1) { create_score_list(hb_result, person1 => 1912, person2 => 2020, person3 => 2040, person4 => nil) }
      let!(:list2) { create_score_list(hl_result, person1 => 2020, person2 => 1912, person3 => 3030, person4 => 1999) }

      context 'male' do
        let(:gender) { :male }

        it 'return results in correct order' do
          rows = subject.rows
          expect(rows).to have(3).entries

          expect(rows.first.sum_result_entry.time).to eq 3932
          expect(rows.first.entity).to eq person2

          expect(rows.second.sum_result_entry.time).to eq 3932
          expect(rows.second.entity).to eq person1

          expect(rows.third.sum_result_entry.time).to eq 5070
          expect(rows.third.entity).to eq person3
        end
      end

      context 'male' do
        let(:gender) { :female }

        it 'return results in correct order' do
          rows = subject.rows
          expect(rows).to have(3).entries

          expect(rows.first.sum_result_entry.time).to eq 3932
          expect(rows.first.entity).to eq person1

          expect(rows.second.sum_result_entry.time).to eq 3932
          expect(rows.second.entity).to eq person2

          expect(rows.third.sum_result_entry.time).to eq 5070
          expect(rows.third.entity).to eq person3
        end
      end
    end
  end
end
