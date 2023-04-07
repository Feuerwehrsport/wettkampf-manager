# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::GroupResult, type: :model do
  let!(:obstacle_course) { create(:assessment, :obstacle_course) }
  let!(:obstacle_course_result) do
    create(:score_result, assessment: obstacle_course, group_score_count: 2, group_run_count: 3, group_assessment: true)
  end

  let!(:team1) { create(:team, :generated) }
  let!(:team1_person1) { create(:person, :generated, team: team1) }
  let!(:team1_person2) { create(:person, :generated, team: team1) }
  let!(:team2) { create(:team, :generated) }
  let!(:team2_person1) { create(:person, :generated, team: team2) }
  let!(:team2_person2) { create(:person, :generated, team: team2) }
  let!(:team2_person3) { create(:person, :generated, team: team2) }
  let!(:team3) { create(:team, :generated) }
  let!(:team3_person1) { create(:person, :generated, team: team3) }
  let!(:team3_person2) { create(:person, :generated, team: team3) }
  let!(:team4) { create(:team, :generated) }
  let!(:team4_person1) { create(:person, :generated, team: team4) }

  let!(:obstacle_course_list) do
    create_score_list(obstacle_course_result,
                      team1_person1 => 1900, team1_person2 => 1950,
                      team2_person1 => 1900, team2_person2 => 2000, team2_person3 => 1999,
                      team3_person1 => 1800, team3_person2 => nil,
                      team4_person1 => 1900)
  end

  describe '.rows' do
    it 'calculates correct results' do
      rows = obstacle_course_result.group_result.rows

      expect(rows.first.team).to eq team1
      expect(rows.first.result_entry.time).to eq 3850
      expect(rows.first.rows_in.count).to eq 2
      expect(rows.first.rows_out.count).to eq 0
      expect(rows.first.competition_result_valid?).to eq true

      expect(rows.second.team).to eq team2
      expect(rows.second.result_entry.time).to eq 3899
      expect(rows.second.rows_in.count).to eq 2
      expect(rows.second.rows_out.count).to eq 1
      expect(rows.second.competition_result_valid?).to eq true

      expect(rows.third.team).to eq team3
      expect(rows.third.result_entry.time).to eq nil
      expect(rows.third.rows_in.count).to eq 2
      expect(rows.third.rows_out.count).to eq 0
      expect(rows.third.competition_result_valid?).to eq true

      expect(rows.fourth.team).to eq team4
      expect(rows.fourth.result_entry.time).to eq nil
      expect(rows.fourth.rows_in.count).to eq 0
      expect(rows.fourth.rows_out.count).to eq 0
      expect(rows.fourth.competition_result_valid?).to eq false
    end
  end

  describe 'supports Certificates::StorageSupport' do
    it 'supports all keys' do
      rows = obstacle_course_result.group_result.rows.map(&:decorate)

      [
        {
          team_name: team1.name,
          person_name: team1.name,
          person_bib_number: '',
          time_long: '38,50 Sekunden',
          time_short: '38,50 s',
          time_without_seconds: '38,50',
          rank: '1.',
          rank_with_rank: '1. Platz',
          rank_without_dot: '1',
          assessment: '100m Hindernisbahn',
          assessment_with_gender: '100m Hindernisbahn - Männer',
          result_name: '100m Hindernisbahn - Männer',
          date: I18n.l(Date.current),
          place: 'Bargeshagen',
          competition_name: 'Wettkampf',
          points: '',
          points_with_points: '',
          text: 'foo',
        },
        {
          team_name: team2.name,
          person_name: team2.name,
          person_bib_number: '',
          time_long: '38,99 Sekunden',
          time_short: '38,99 s',
          time_without_seconds: '38,99',
          rank: '2.',
          rank_with_rank: '2. Platz',
          rank_without_dot: '2',
          assessment: '100m Hindernisbahn',
          assessment_with_gender: '100m Hindernisbahn - Männer',
          result_name: '100m Hindernisbahn - Männer',
          date: I18n.l(Date.current),
          place: 'Bargeshagen',
          competition_name: 'Wettkampf',
          points: '',
          points_with_points: '',
          text: 'foo',
        },
        {
          team_name: team3.name,
          person_name: team3.name,
          person_bib_number: '',
          time_long: 'Ungültig',
          time_short: 'D',
          time_without_seconds: '-',
          rank: '3.',
          rank_with_rank: '3. Platz',
          rank_without_dot: '3',
          assessment: '100m Hindernisbahn',
          assessment_with_gender: '100m Hindernisbahn - Männer',
          result_name: '100m Hindernisbahn - Männer',
          date: I18n.l(Date.current),
          place: 'Bargeshagen',
          competition_name: 'Wettkampf',
          points: '',
          points_with_points: '',
          text: 'foo',
        },
        {
          team_name: team4.name,
          person_name: team4.name,
          person_bib_number: '',
          time_long: 'Ungültig',
          time_short: 'D',
          time_without_seconds: '-',
          rank: '4.',
          rank_with_rank: '4. Platz',
          rank_without_dot: '4',
          assessment: '100m Hindernisbahn',
          assessment_with_gender: '100m Hindernisbahn - Männer',
          result_name: '100m Hindernisbahn - Männer',
          date: I18n.l(Date.current),
          place: 'Bargeshagen',
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
