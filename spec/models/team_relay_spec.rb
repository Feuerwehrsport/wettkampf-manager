require 'rails_helper'

RSpec.describe TeamRelay, type: :model do
  describe '#name' do
    let(:team_relay) { build(:team_relay) }

    it 'replaces numbers with letters' do
      expect(team_relay.name).to eq 'A'
    end
  end

  describe '.create_next_free' do
    let(:team) { create :team }
    let!(:team_relay_a) { create(:team_relay, team: team) }

    it 'creates new team_relays for team' do
      # team A already exists
      expect(team_relay_a.name).to eq 'A'

      team_relay_b = TeamRelay.create_next_free(team)
      expect(team_relay_b).to be_a(TeamRelay)
      expect(team_relay_b.name).to eq 'B'

      team_relay_c = TeamRelay.create_next_free(team)
      expect(team_relay_c).to be_a(TeamRelay)
      expect(team_relay_c.name).to eq 'C'
    end
  end

  describe '.create_next_free_for' do
    let(:team) { create :team }
    let!(:team_relay_a) { create(:team_relay, team: team) }

    context 'when no ids are set before' do
      it 'returns existing relay' do
        team_relay = TeamRelay.create_next_free_for(team, [])
        expect(team_relay).to eq team_relay_a
      end
    end

    context 'when used ids are set before' do
      it 'returns creates new relay' do
        team_relay = TeamRelay.create_next_free_for(team, [team_relay_a.id])
        expect(team_relay).not_to eq team_relay_a
        expect(team_relay).to be_a(TeamRelay)
        expect(team_relay.name).to eq 'B'
      end
    end
  end
end
