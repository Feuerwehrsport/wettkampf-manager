require 'rails_helper'

RSpec.describe Person, type: :model do
  describe 'validation' do
    let(:team_male) { build_stubbed(:team, :male) }
    let(:team_female) { build_stubbed(:team, :female) }

    context 'when team gender is not person gender' do
      let(:person) { build(:person, :male, team: team_female) }

      it 'fails on validation' do
        expect(person).not_to be_valid
        expect(person).to have(1).errors_on(:team)
      end
    end

    context 'when team gender is person gender' do
      let(:person) { build(:person, :male, team: team_male) }

      it 'fails on validation' do
        expect(person).to be_valid
      end
    end
  end
end
