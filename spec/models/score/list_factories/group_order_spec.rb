# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListFactories::GroupOrder, type: :model do
  let(:factory) do
    create(:score_list_factory_group_order, assessments: [assessment], discipline: assessment.discipline)
  end

  describe '#perform_rows' do
    let(:list) { build_stubbed :score_list, assessments: [assessment] }
    let(:assessment) { create :assessment }

    let(:team1) { create(:team, :generated) }
    let(:person1_team1) { create(:person, :generated, team: team1) }
    let(:person2_team1) { create(:person, :generated, team: team1) }
    let(:person3_team1) { create(:person, :generated, team: team1) }
    let(:person4_team1) { create(:person, :generated, team: team1) }
    let(:person5_team1) { create(:person, :generated, team: team1) }
    let(:person6_team1) { create(:person, :generated, team: team1) }

    let(:team2) { create(:team, :generated) }
    let(:person1_team2) { create(:person, :generated, team: team2) }
    let(:person2_team2) { create(:person, :generated, team: team2) }
    let(:person3_team2) { create(:person, :generated, team: team2) }
    let(:person4_team2) { create(:person, :generated, team: team2) }

    let(:team3) { create(:team, :generated) }
    let(:person1_team3) { create(:person, :generated, team: team3) }
    let(:person2_team3) { create(:person, :generated, team: team3) }
    let(:person3_team3) { create(:person, :generated, team: team3) }

    before do
      create_assessment_request(person1_team1, assessment, 1)
      create_assessment_request(person2_team1, assessment, 2)
      create_assessment_request(person3_team1, assessment, 3)
      create_assessment_request(person4_team1, assessment, 0, 1, :single_competitor)
      create_assessment_request(person5_team1, assessment, 0, 2, :single_competitor)
      create_assessment_request(person6_team1, assessment, 0, 3, :single_competitor)

      create_assessment_request(person1_team2, assessment, 1)
      create_assessment_request(person2_team2, assessment, 2)
      create_assessment_request(person3_team2, assessment, 3)
      create_assessment_request(person4_team2, assessment, 0, 1, :single_competitor)

      create_assessment_request(person1_team3, assessment, 1)
      create_assessment_request(person2_team3, assessment, 2)
      create_assessment_request(person3_team3, assessment, 3)
    end

    it 'returns requests seperated by team and group competitor order' do
      requests = factory.send(:perform_rows)
      expect(requests).to have(13).items

      requests_team1 = requests.select { |r| r.entity.team == team1 }
      expect(requests_team1.map(&:entity)).to eq [
        person4_team1,
        person5_team1,
        person6_team1,
        person1_team1,
        person2_team1,
        person3_team1,
      ]

      requests_team2 = requests.select { |r| r.entity.team == team2 }
      expect(requests_team2.map(&:entity)).to eq [
        person4_team2,
        person1_team2,
        person2_team2,
        person3_team2,
      ]

      requests_team3 = requests.select { |r| r.entity.team == team3 }
      expect(requests_team3.map(&:entity)).to eq [
        person1_team3,
        person2_team3,
        person3_team3,
      ]
    end
  end
end
