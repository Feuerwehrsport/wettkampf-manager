require 'rails_helper'

RSpec.describe Score::ListFactories::TrackGenderable, type: :model do
  let(:factory) do
    build(:score_list_factory_track_genderable, track: track, gender: gender,
                                                assessments: [assessment_male, assessment_female])
  end
  let(:assessment_male) { create(:assessment, gender: :male) }
  let(:assessment_female) { create(:assessment, gender: :female) }
  let(:track) { 3 }
  let(:gender) { nil }

  describe 'validation' do
    it 'validates track and gender' do
      expect(factory).not_to be_valid
      expect(factory).to have(1).error_on(:track)
      expect(factory).to have(1).error_on(:gender)
    end

    context 'with correct values' do
      let(:track) { 1 }
      let(:gender) { :female }

      it 'is valid' do
        expect(factory).to be_valid
      end
    end
  end

  context 'when assessment requests present' do
    let(:track) { 1 }
    let(:gender) { :female }

    let(:team1) { create(:team, :generated, gender: :male) }
    let(:person1_team1) { create(:person, :generated, team: team1, gender: :male, last_name: 'Male1') }
    let(:person2_team1) { create(:person, :generated, team: team1, gender: :male, last_name: 'Male1') }
    let(:person3_team1) { create(:person, :generated, team: team1, gender: :male, last_name: 'Male1-Single') }

    let(:team2) { create(:team, :generated, gender: :male) }
    let(:person1_team2) { create(:person, :generated, team: team2, gender: :male, last_name: 'Male2') }

    let(:team3) { create(:team, :generated, gender: :female) }
    let(:person1_team3) { create(:person, :generated, team: team3, gender: :female) }
    let(:person2_team3) { create(:person, :generated, team: team3, gender: :female) }

    before do
      create_assessment_request(person1_team1, assessment_male, 1)
      create_assessment_request(person2_team1, assessment_male, 2)
      create_assessment_request(person3_team1, assessment_male, 0, 1, :single_competitor)

      create_assessment_request(person1_team2, assessment_male, 1)

      create_assessment_request(person1_team3, assessment_female, 1)
      create_assessment_request(person2_team3, assessment_female, 2)
    end

    describe '#perform_rows' do
      it 'returns requests seperated by team and group competitor order' do
        requests = factory.send(:perform_rows)
        expect(requests).to have(6).items

        requests_team1 = requests.select { |r| r.entity.team == team1 }
        expect(requests_team1.map(&:entity)).to eq [
          person3_team1,
          person1_team1,
          person2_team1,
        ]

        requests_team2 = requests.select { |r| r.entity.team == team2 }
        expect(requests_team2.map(&:entity)).to eq [
          person1_team2,
        ]

        requests_team3 = requests.select { |r| r.entity.team == team3 }
        expect(requests_team3.map(&:entity)).to eq [
          person1_team3,
          person2_team3,
        ]
      end
    end

    describe '#perform' do
      it 'creates list entries' do
        factory.send(:perform)
        expect(factory.list.entries.count).to eq 6
        expect(factory.list.entries.where(track: 1).order(:run).map(&:entity)).to eq [
          person1_team3,
          person2_team3,
        ]
        males = factory.list.entries.where(track: 2).order(:run).map(&:entity)
        if males.first == person1_team2
          expect(males).to eq [
            person1_team2,
            person3_team1,
            person1_team1,
            person2_team1,
          ]
        else
          expect(males).to eq [
            person3_team1,
            person1_team2,
            person1_team1,
            person2_team1,
          ]
        end
      end
    end
  end
end
