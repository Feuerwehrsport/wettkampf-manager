# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  let(:band_male) { build_stubbed(:band) }
  let(:band_female) { build_stubbed(:band, :female) }

  describe 'validation' do
    let(:team_male) { build_stubbed(:team, :male, band: band_male) }
    let(:team_female) { build_stubbed(:team, :female, band: band_female) }

    context 'when team band is not person band' do
      let(:person) { build(:person, :male, team: team_female, band: band_male) }

      it 'fails on validation' do
        expect(person).not_to be_valid
        expect(person).to have(1).errors_on(:team)
      end
    end

    context 'when team band is person band' do
      let(:person) { build(:person, :male, team: team_male, band: band_male) }

      it 'fails on validation' do
        expect(person).to be_valid
      end
    end
  end
end
