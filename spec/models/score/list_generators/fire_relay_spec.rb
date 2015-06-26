require 'rails_helper'

RSpec.describe Score::ListGenerators::FireRelay, type: :model do
  
  describe '#perform_rows' do
    let(:list) { build_stubbed :score_list, assessments: [assessment] }
    let(:generator) { described_class.new(list: list) }
    let(:assessment) { create :assessment }
    let!(:assessment_request1) { create :assessment_request, assessment: assessment, relay_count: 2 }
    let!(:assessment_request2) { create :assessment_request, assessment: assessment, relay_count: 1 }
    let!(:assessment_request3) { create :assessment_request, assessment: assessment, relay_count: 2 }

    it "returns created team relays in request structs" do
      team_relay_requests = generator.send(:perform_rows)
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

  describe "validation" do
    let(:assessment) { build_stubbed :assessment }
    let(:list) { build_stubbed :score_list, assessments: [assessment] }
    let(:generator) { described_class.new(best_count: 2, list: list) }

    it "validates assessment for fire relay discipline" do
      expect(generator.valid?).to be_falsey
      expect(generator).to have(1).error_on(:base)
    end

    context "with fire relay assessment" do
      let(:assessment) { build_stubbed :assessment, :fire_relay }
      it "is valid" do
        expect(generator.valid?).to be_truthy
      end
    end
  end
end
