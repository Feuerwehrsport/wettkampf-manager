require 'rails_helper'

RSpec.describe Score::ListFactories::FireRelay, type: :model do
  let(:assessment) { create(:assessment, :fire_relay) }
  subject { create(:score_list_factory_fire_relay, assessments: [assessment], discipline: assessment.discipline) }
  
  describe '#perform_rows' do
    let!(:assessment_request1) { create :assessment_request, assessment: assessment, relay_count: 2 }
    let!(:assessment_request2) { create :assessment_request, assessment: assessment, relay_count: 1 }
    let!(:assessment_request3) { create :assessment_request, assessment: assessment, relay_count: 2 }

    it "returns created team relays in request structs" do
      team_relay_requests = subject.send(:perform_rows)
      team_relays = team_relay_requests.map(&:entity)
      expect(team_relays).to have(5).items
      expect(team_relays.map(&:name)).to eq ["A", "A", "A", "B", "B"]

      team1_requests = team_relays.select { |tr| tr.team == assessment_request1.entity }
      expect(team1_requests.map(&:name)).to eq ["A", "B"]

      team2_requests = team_relays.select { |tr| tr.team == assessment_request2.entity }
      expect(team2_requests.map(&:name)).to eq ["A"]

      team3_requests = team_relays.select { |tr| tr.team == assessment_request3.entity }
      expect(team3_requests.map(&:name)).to eq ["A", "B"]
    end
  end
end
