# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe '#create_assessment_requests' do
    let(:team) { create(:team) }
    let!(:fire_attack_assessment) { create :assessment, :fire_attack }
    let!(:fire_relay_assessment) { create :assessment, :fire_relay }
    let!(:obstacle_course_assessment) { create :assessment, :obstacle_course }

    it 'creates assessment requests for all available assessments' do
      requests = team.requests
      expect(requests).to have(2).items
      expect(requests.first.assessment).to eq fire_attack_assessment
      expect(requests.first.relay_count).to eq 1
      expect(requests.second.assessment).to eq fire_relay_assessment
      expect(requests.second.relay_count).to eq 2
    end
  end
end
