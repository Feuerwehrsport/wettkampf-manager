require 'rails_helper'

RSpec.describe Score::ListGenerators::GroupOrder, type: :model do
  
  describe '#perform_rows' do
    let(:list) { build_stubbed :score_list, assessment: assessment }
    let(:generator) { described_class.new(list: list) }
    let(:assessment) { create :assessment }

    let(:team1) { create(:team, :generated) }
    let(:person1_team1) { create(:person, :generated, team: team1) }
    let(:person2_team1) { create(:person, :generated, team: team1) }
    let(:person3_team1) { create(:person, :generated, team: team1) }
    let(:person4_team1) { create(:person, :generated, team: team1) }

    let(:team2) { create(:team, :generated) }
    let(:person1_team2) { create(:person, :generated, team: team1) }
    let(:person2_team2) { create(:person, :generated, team: team1) }
    let(:person3_team2) { create(:person, :generated, team: team1) }
    let(:person4_team2) { create(:person, :generated, team: team1) }
    
    let(:team3) { create(:team, :generated) }
    let(:person1_team3) { create(:person, :generated, team: team1) }
    let(:person2_team3) { create(:person, :generated, team: team1) }
    let(:person3_team3) { create(:person, :generated, team: team1) }

    before do
      create_assessment_request(person1_team1, 1)
      create_assessment_request(person2_team1, 2)
      create_assessment_request(person3_team1, 3)
      create_assessment_request(person4_team1, 0, :single_competitor)

      create_assessment_request(person1_team2, 1)
      create_assessment_request(person2_team2, 2)
      create_assessment_request(person3_team2, 3)
      create_assessment_request(person4_team2, 0, :single_competitor)

      create_assessment_request(person1_team3, 1)
      create_assessment_request(person2_team3, 2)
      create_assessment_request(person3_team3, 3)
    end
    
    it "returns requests seperated by team and group competitor order" do
      requests = generator.send(:perform_rows)
      expect(requests).to have(11).items
    end
  end
end

def create_assessment_request(entity, group_competitor_order, assessment_type=:group_competitor)
  create(:assessment_request, 
    assessment: assessment,
    entity: entity, 
    group_competitor_order: group_competitor_order,
    assessment_type: assessment_type,
  )
end
