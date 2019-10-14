require 'rails_helper'

RSpec.describe Score::DoubleEventResult, type: :model do
  let(:double_event_result) { described_class.create!(assessment: zk_assessment) }

  let(:hl_assessment) { create(:assessment, discipline: create(:climbing_hook_ladder), gender: gender) }
  let(:hl_result) { create :score_result, assessment: hl_assessment, double_event_result: double_event_result }
  let(:hb_assessment) { create(:assessment, discipline: create(:obstacle_course), gender: gender) }
  let(:hb_result) { create :score_result, assessment: hb_assessment, double_event_result: double_event_result }
  let(:zk_assessment) { create(:assessment, discipline: create(:double_event), gender: gender) }

  describe '.rows' do
    let(:person1) { create :person, :generated, gender: gender }
    let(:person2) { create :person, :generated, gender: gender }
    let(:person3) { create :person, :generated, gender: gender }
    let(:person4) { create :person, :generated, gender: gender }

    context 'when entries given' do
      let!(:list1) { create_score_list(hb_result, person1 => 1912, person2 => 2020, person3 => 2040, person4 => nil) }
      let!(:list2) { create_score_list(hl_result, person1 => 2020, person2 => 1912, person3 => 3030, person4 => 1999) }

      context 'when male' do
        let(:gender) { :male }

        it 'return results in correct order' do
          rows = double_event_result.rows
          expect(rows).to have(3).entries

          expect(rows.first.sum_result_entry.time).to eq 3932
          expect(rows.first.entity).to eq person2

          expect(rows.second.sum_result_entry.time).to eq 3932
          expect(rows.second.entity).to eq person1

          expect(rows.third.sum_result_entry.time).to eq 5070
          expect(rows.third.entity).to eq person3
        end
      end

      context 'when female' do
        let(:gender) { :female }

        it 'return results in correct order' do
          rows = double_event_result.rows
          expect(rows).to have(3).entries

          expect(rows.first.sum_result_entry.time).to eq 3932
          expect(rows.first.entity).to eq person1

          expect(rows.second.sum_result_entry.time).to eq 3932
          expect(rows.second.entity).to eq person2

          expect(rows.third.sum_result_entry.time).to eq 5070
          expect(rows.third.entity).to eq person3
        end

        describe 'supports Certificates::StorageSupport' do
          it 'supports all keys' do
            rows = double_event_result.rows.map(&:decorate)

            [
              {
                team_name: '',
                person_name: person1.decorate.full_name,
                person_bib_number: '',
                time_long: '39,32 Sekunden',
                time_short: '39,32 s',
                time_without_seconds: '39,32',
                rank: '1.',
                rank_with_rank: '1. Platz',
                rank_without_dot: '1',
                assessment: 'Zweikampf',
                assessment_with_gender: 'Zweikampf - Frauen',
                result_name: 'Zweikampf - Frauen',
                gender: 'Frauen',
                date: I18n.l(Date.current),
                place: '',
                competition_name: 'Wettkampf',
                points: '',
                points_with_points: '',
                text: 'foo',
              },
              {
                team_name: '',
                person_name: person2.decorate.full_name,
                person_bib_number: '',
                time_long: '39,32 Sekunden',
                time_short: '39,32 s',
                time_without_seconds: '39,32',
                rank: '2.',
                rank_with_rank: '2. Platz',
                rank_without_dot: '2',
                assessment: 'Zweikampf',
                assessment_with_gender: 'Zweikampf - Frauen',
                result_name: 'Zweikampf - Frauen',
                gender: 'Frauen',
                date: I18n.l(Date.current),
                place: '',
                competition_name: 'Wettkampf',
                points: '',
                points_with_points: '',
                text: 'foo',
              },
              {
                team_name: '',
                person_name: person3.decorate.full_name,
                person_bib_number: '',
                time_long: '50,70 Sekunden',
                time_short: '50,70 s',
                time_without_seconds: '50,70',
                rank: '3.',
                rank_with_rank: '3. Platz',
                rank_without_dot: '3',
                assessment: 'Zweikampf',
                assessment_with_gender: 'Zweikampf - Frauen',
                result_name: 'Zweikampf - Frauen',
                gender: 'Frauen',
                date: I18n.l(Date.current),
                place: '',
                competition_name: 'Wettkampf',
                points: '',
                points_with_points: '',
                text: 'foo',
              },
            ].each_with_index do |row_match, index|
              row_match.each do |key, value|
                expect(rows[index].get(OpenStruct.new(key: key, text: 'foo')).to_s).to eq value
              end
            end
          end
        end
      end
    end
  end
end
