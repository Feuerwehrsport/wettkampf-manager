require 'rails_helper'

RSpec.describe FireSportStatistics::ImportSuggestions, type: :model do
  describe 'import process' do
    let(:person) do
      { id: 1757, last_name: 'Abel', first_name: 'Edmund', gender: 'male',
        best_scores: { 'pb' => { 'hb' => [1234, 'Wettkampf'] } } }
    end
    let(:team) { { id: 1108, name: 'Zwickauer Land', shortcut: 'Zwickauer Land', state: 'SN' } }
    let(:team_member) { { person_id: 1757, team_id: 1108 } }
    let(:team_spelling) { { team_id: 1108, name: 'FF Putpus', shortcut: 'Putpus' } }
    let(:person_spelling) { { person_id: 1757, first_name: 'Emely', last_name: 'Heyne', gender: 'female' } }
    let(:series_round) { { id: 68, name: 'BB-Cup', year: 2019, aggregate_type: 'BrandenburgCup' } }
    let(:series_cup) { { id: 531, round_id: 68, date: '2017-08-05', place: 'Tryppehna' } }
    let(:series_assessment) do
      { id: 812, gender: 'male', name: 'Löschangriff nass - männlich', discipline: 'la',
        round_id: 68, type: 'Series::TeamAssessment' }
    end
    let(:series_participation) do
      { id: 35_603, points: 6, rank: 5, time: 7932, assessment_id: 812, cup_id: 531, type: 'Series::TeamParticipation',
        team_id: 1108, team_number: 1, person_id: nil, participation_type: 'team' }
    end
    let(:related_classes) do
      [
        FireSportStatistics::TeamAssociation,
        FireSportStatistics::TeamSpelling,
        FireSportStatistics::PersonSpelling,
        FireSportStatistics::Team,
        FireSportStatistics::Person,
        Series::Participation,
        Series::Assessment,
        Series::Cup,
        Series::Round,
      ]
    end

    it 'imports all' do
      expect(related_classes).to all(receive(:delete_all))
      expect(Series::Cup).to receive(:create_today!)

      {
        [:people, extended: 1] => person,
        [:teams, nil] => team,
        [:team_members, nil] => team_member,
        [:team_spellings, nil] => team_spelling,
        [:person_spellings, nil] => person_spelling,
        ['series/rounds', nil] => series_round,
        ['series/cups', nil] => series_cup,
        ['series/assessments', nil] => series_assessment,
        ['series/participations', nil] => series_participation,
      }.each do |api, hash|
        expect(FireSportStatistics::API::Get).to receive(:fetch).with(*api).and_return([OpenStruct.new(hash)])
      end

      described_class.new(true)

      related_classes.each { |klass| expect(klass.count).to eq 1 }

      expect(FireSportStatistics::Person.first.personal_best_hb).to eq 1234
      expect(FireSportStatistics::Person.first.personal_best_hb_competition).to eq 'Wettkampf'
    end
  end
end
