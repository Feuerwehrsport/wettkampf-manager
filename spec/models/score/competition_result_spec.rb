# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::CompetitionResult, type: :model do
  let(:competition_result) { create(:score_competition_result) }

  let!(:fire_attack) { create(:assessment, :fire_attack, score_competition_result: competition_result) }
  let!(:fire_attack_result) { create(:score_result, assessment: fire_attack, group_assessment: true) }
  let!(:fire_relay) { create(:assessment, :fire_relay, score_competition_result: competition_result) }
  let!(:fire_relay_result) { create(:score_result, assessment: fire_relay, group_assessment: true) }
  let!(:obstacle_course) { create(:assessment, :obstacle_course, score_competition_result: competition_result) }
  let!(:obstacle_course_result) do
    create(:score_result, assessment: obstacle_course, group_score_count: 2, group_run_count: 3, group_assessment: true)
  end

  let!(:team1) { create(:team, :generated) }
  let!(:team1_person1) { create(:person, :generated, team: team1) }
  let!(:team1_person2) { create(:person, :generated, team: team1) }
  let!(:team1_a) { TeamRelay.find_or_create_by!(team: team1, number: 1) }
  let!(:team2) { create(:team, :generated) }
  let!(:team2_person1) { create(:person, :generated, team: team2) }
  let!(:team2_person2) { create(:person, :generated, team: team2) }
  let!(:team2_person3) { create(:person, :generated, team: team2) }
  let!(:team2_a) { TeamRelay.find_or_create_by!(team: team2, number: 1) }
  let!(:team3) { create(:team, :generated) }
  let!(:team3_person1) { create(:person, :generated, team: team3) }
  let!(:team3_person2) { create(:person, :generated, team: team3) }
  let!(:team3_a) { TeamRelay.find_or_create_by!(team: team3, number: 1) }
  let!(:team3_b) { TeamRelay.find_or_create_by!(team: team3, number: 2) }
  let!(:team4) { create(:team, :generated) }
  let!(:team4_person1) { create(:person, :generated, team: team4) }

  let!(:fire_attack_list) { create_score_list(fire_attack_result, team1 => 2200, team2 => 2300, team3 => nil) }
  let!(:obstacle_course_list) do
    create_score_list(obstacle_course_result,
                      team1_person1 => 1900, team1_person2 => 1950,
                      team2_person1 => 1900, team2_person2 => 2000, team2_person3 => 1999,
                      team3_person1 => 1800, team3_person2 => nil,
                      team4_person1 => 1900)
  end
  let!(:fire_relay_list) do
    create_score_list(fire_relay_result, team1_a => 6000, team2_a => 6001, team3_a => 60_002, team3_b => 5999)
  end

  describe '.dcup' do
    it 'calculates correct results' do
      rows = competition_result.send(:dcup)
      expect(rows.first.points).to eq 29
      expect(rows.first.team).to eq team1
      expect(rows.first.assessment_result_from(fire_attack).points).to eq 10
      expect(rows.first.assessment_result_from(obstacle_course).points).to eq 10
      expect(rows.first.assessment_result_from(obstacle_course).row.result_entry.time).to eq 3850
      expect(rows.first.assessment_result_from(fire_relay).points).to eq 9

      expect(rows.second.points).to eq 26
      expect(rows.second.team).to eq team2
      expect(rows.second.assessment_result_from(fire_attack).points).to eq 9
      expect(rows.second.assessment_result_from(obstacle_course).points).to eq 9
      expect(rows.second.assessment_result_from(obstacle_course).row.result_entry.time).to eq 3899
      expect(rows.second.assessment_result_from(fire_relay).points).to eq 8

      expect(rows.third.points).to eq 26
      expect(rows.third.team).to eq team3
      expect(rows.third.assessment_result_from(fire_attack).points).to eq 8
      expect(rows.third.assessment_result_from(obstacle_course).points).to eq 8
      expect(rows.third.assessment_result_from(obstacle_course).row.result_entry.time).to eq nil
      expect(rows.third.assessment_result_from(fire_relay).points).to eq 10

      expect(rows.fourth.points).to eq 0
      expect(rows.fourth.team).to eq team4
      expect(rows.fourth.assessment_result_from(fire_attack)).to be_nil
      expect(rows.fourth.assessment_result_from(obstacle_course).points).to eq 0
      expect(rows.fourth.assessment_result_from(obstacle_course).row.result_entry.time).to eq nil
      expect(rows.fourth.assessment_result_from(fire_relay)).to be_nil
    end
  end

  describe '.places_to_points' do
    let(:competition_result) { create(:score_competition_result, result_type: 'places_to_points') }

    it 'calculates correct results' do
      rows = competition_result.send(:places_to_points)
      expect(rows.first.points).to eq 4
      expect(rows.first.team).to eq team1
      expect(rows.first.assessment_result_from(fire_attack).points).to eq 1
      expect(rows.first.assessment_result_from(obstacle_course).points).to eq 1
      expect(rows.first.assessment_result_from(obstacle_course).row.result_entry.time).to eq 3850
      expect(rows.first.assessment_result_from(fire_relay).points).to eq 2

      expect(rows.second.points).to eq 7
      expect(rows.second.team).to eq team2
      expect(rows.second.assessment_result_from(fire_attack).points).to eq 2
      expect(rows.second.assessment_result_from(obstacle_course).points).to eq 2
      expect(rows.second.assessment_result_from(obstacle_course).row.result_entry.time).to eq 3899
      expect(rows.second.assessment_result_from(fire_relay).points).to eq 3

      expect(rows.third.points).to eq 7
      expect(rows.third.team).to eq team3
      expect(rows.third.assessment_result_from(fire_attack).points).to eq 3
      expect(rows.third.assessment_result_from(obstacle_course).points).to eq 3
      expect(rows.third.assessment_result_from(obstacle_course).row.result_entry.time).to eq nil
      expect(rows.third.assessment_result_from(fire_relay).points).to eq 1

      expect(rows.fourth.points).to eq 12
      expect(rows.fourth.team).to eq team4
      expect(rows.fourth.assessment_result_from(fire_attack).points).to eq 4
      expect(rows.fourth.assessment_result_from(obstacle_course).points).to eq 4
      expect(rows.fourth.assessment_result_from(obstacle_course).row.result_entry.time).to eq nil
      expect(rows.fourth.assessment_result_from(fire_relay).points).to eq 4
    end
  end

  describe 'some export features' do
    it 'renders PDF' do
      pdf = Exports::PDF::Score::CompetitionResults.perform([competition_result.decorate])
      expect(pdf.bytestream).to start_with '%PDF-1.3'
      expect(pdf.bytestream).to end_with "%%EOF\n"
    end
  end

  describe 'supports Certificates::StorageSupport' do
    let(:competition_result) { create(:score_competition_result, result_type: 'dcup') }

    it 'supports all keys' do
      rows = competition_result.decorate.rows

      [
        {
          team_name: team1.name,
          person_name: team1.name,
          person_bib_number: '',
          time_long: '',
          time_short: '',
          time_without_seconds: '',
          rank: '1.',
          rank_with_rank: '1. Platz',
          rank_without_dot: '1',
          assessment: '',
          assessment_with_gender: '',
          result_name: 'Wettkampf - Männer',
          date: I18n.l(Date.current),
          place: 'Bargeshagen',
          competition_name: 'Wettkampf',
          points: '29',
          points_with_points: '29 Punkte',
          text: 'foo',
        },
        {
          team_name: team2.name,
          person_name: team2.name,
          person_bib_number: '',
          time_long: '',
          time_short: '',
          time_without_seconds: '',
          rank: '2.',
          rank_with_rank: '2. Platz',
          rank_without_dot: '2',
          assessment: '',
          assessment_with_gender: '',
          result_name: 'Wettkampf - Männer',
          date: I18n.l(Date.current),
          place: 'Bargeshagen',
          competition_name: 'Wettkampf',
          points: '26',
          points_with_points: '26 Punkte',
          text: 'foo',
        },
        {
          team_name: team3.name,
          person_name: team3.name,
          person_bib_number: '',
          time_long: '',
          time_short: '',
          time_without_seconds: '',
          rank: '3.',
          rank_with_rank: '3. Platz',
          rank_without_dot: '3',
          assessment: '',
          assessment_with_gender: '',
          result_name: 'Wettkampf - Männer',
          date: I18n.l(Date.current),
          place: 'Bargeshagen',
          competition_name: 'Wettkampf',
          points: '26',
          points_with_points: '26 Punkte',
          text: 'foo',
        },
        {
          team_name: team4.name,
          person_name: team4.name,
          person_bib_number: '',
          time_long: '',
          time_short: '',
          time_without_seconds: '',
          rank: '4.',
          rank_with_rank: '4. Platz',
          rank_without_dot: '4',
          assessment: '',
          assessment_with_gender: '',
          result_name: 'Wettkampf - Männer',
          date: I18n.l(Date.current),
          place: 'Bargeshagen',
          competition_name: 'Wettkampf',
          points: '0',
          points_with_points: '0 Punkte',
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
