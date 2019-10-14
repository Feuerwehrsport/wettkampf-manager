require 'rails_helper'

RSpec.describe Score::Result, type: :model do
  let(:result) { create :score_result, tags: tags }
  let(:tags) { [] }

  describe '.rows' do
    let(:person1) { create :person, :generated, tags: tags }
    let(:person2) { create :person, :generated }
    let(:person3) { create :person, :generated }
    let(:person4) { create :person, :generated }

    context 'when entries given' do
      let(:time4) { 2040 }
      let!(:list1) { create_score_list(result, person1 => 1912, person2 => 2020, person3 => 2040, person4 => nil) }
      let!(:list2) { create_score_list(result, person1 => nil, person2 => 1911, person3 => 1912, person4 => time4) }

      it 'return results in correct order' do
        rows = result.rows
        expect(rows).to have(4).entries

        expect(rows.first.result_entry_from(list1).time).to eq 2020
        expect(rows.first.result_entry_from(list2).time).to eq 1911
        expect(rows.first.best_result_entry.time).to eq 1911

        expect(rows.second.result_entry_from(list1).time).to eq 2040
        expect(rows.second.result_entry_from(list2).time).to eq 1912
        expect(rows.second.best_result_entry.time).to eq 1912

        expect(rows.third.result_entry_from(list1).time).to eq 1912
        expect(rows.third.result_entry_from(list2).time).to be_nil
        expect(rows.third.best_result_entry.time).to eq 1912

        expect(rows.last.result_entry_from(list1).time).to be_nil
        expect(rows.last.result_entry_from(list2).time).to eq 2040
        expect(rows.last.best_result_entry.time).to eq 2040
      end

      describe 'supports Certificates::StorageSupport' do
        let(:time4) { nil }

        it 'supports all keys' do
          rows = result.rows.map(&:decorate)

          [
            {
              team_name: '',
              person_name: person2.decorate.full_name,
              person_bib_number: '',
              time_long: '19,11 Sekunden',
              time_short: '19,11 s',
              time_without_seconds: '19,11',
              rank: '1.',
              rank_with_rank: '1. Platz',
              rank_without_dot: '1',
              assessment: 'Hakenleitersteigen',
              assessment_with_gender: 'Hakenleitersteigen - Männer',
              result_name: 'Hakenleitersteigen - Männer',
              gender: 'Männer',
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
              time_long: '19,12 Sekunden',
              time_short: '19,12 s',
              time_without_seconds: '19,12',
              rank: '2.',
              rank_with_rank: '2. Platz',
              rank_without_dot: '2',
              assessment: 'Hakenleitersteigen',
              assessment_with_gender: 'Hakenleitersteigen - Männer',
              result_name: 'Hakenleitersteigen - Männer',
              gender: 'Männer',
              date: I18n.l(Date.current),
              place: '',
              competition_name: 'Wettkampf',
              points: '',
              points_with_points: '',
              text: 'foo',
            },
            {
              team_name: '',
              person_name: person1.decorate.full_name,
              person_bib_number: '',
              time_long: '19,12 Sekunden',
              time_short: '19,12 s',
              time_without_seconds: '19,12',
              rank: '3.',
              rank_with_rank: '3. Platz',
              rank_without_dot: '3',
              assessment: 'Hakenleitersteigen',
              assessment_with_gender: 'Hakenleitersteigen - Männer',
              result_name: 'Hakenleitersteigen - Männer',
              gender: 'Männer',
              date: I18n.l(Date.current),
              place: '',
              competition_name: 'Wettkampf',
              points: '',
              points_with_points: '',
              text: 'foo',
            },
            {
              team_name: '',
              person_name: person4.decorate.full_name,
              person_bib_number: '',
              time_long: 'Ungültig',
              time_short: 'D',
              time_without_seconds: '-',
              rank: '4.',
              rank_with_rank: '4. Platz',
              rank_without_dot: '4',
              assessment: 'Hakenleitersteigen',
              assessment_with_gender: 'Hakenleitersteigen - Männer',
              result_name: 'Hakenleitersteigen - Männer',
              gender: 'Männer',
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

      context 'when person tags present' do
        let(:tags) { [create(:person_tag)] }

        it 'supports all keys' do
          rows = result.rows.map(&:decorate)

          [
            {
              team_name: '',
              person_name: person1.decorate.full_name,
              person_bib_number: '',
              time_long: '19,12 Sekunden',
              time_short: '19,12 s',
              time_without_seconds: '19,12',
              rank: '1.',
              rank_with_rank: '1. Platz',
              rank_without_dot: '1',
              assessment: 'Hakenleitersteigen',
              assessment_with_gender: 'Hakenleitersteigen - Männer',
              result_name: 'Hakenleitersteigen - Männer - U20',
              gender: 'Männer',
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

    context 'when entries similar' do
      let!(:list1) { create_score_list(result, person1 => 1912, person2 => 1912) }
      let!(:list2) { create_score_list(result, person2 => 1913) }

      it 'return results in correct order' do
        rows = result.rows
        expect(rows).to have(2).entries

        expect(rows.first.entity).to eq person2
        expect(rows.first.result_entry_from(list1).time).to eq 1912
        expect(rows.first.result_entry_from(list2).time).to eq 1913

        expect(rows.second.entity).to eq person1
        expect(rows.second.result_entry_from(list1).time).to eq 1912
        expect(rows.second.result_entry_from(list2)).to be_nil
      end
    end
  end
end
