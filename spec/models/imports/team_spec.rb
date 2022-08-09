# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Imports::Team, type: :model do
  describe '#clean_and_cut_shortcut' do
    it 'truncates team names' do
      {
        'FF Warin' => 'Warin',
        'Team Mecklenburg-Vorpommern' => 'Mecklenburg-',
        'Wettkampfteam Dresden - Bühlau' => 'Dresden-Bühl',
        'Wettkampfgruppe Anderswo' => 'Anderswo',
        'Freiwillige Feuerwehr Rostock' => 'Rostock',
        'Feuerwehr Admannshagen-Bargeshagen' => 'Admannshagen',
        'Team Lausitz' => 'Lausitz',
        'BF Cottbus' => 'Cottbus',
        'Ostseebad Nienhagen' => 'Nienhagen',
        'FF Ostseebad Nienhagen' => 'Nienhagen',
        'Feuerwehr Ostseebad Nienhagen' => 'Nienhagen',
        'Freiwillige Feuerwehr Ostseebad Nienhagen' => 'Nienhagen',
        'Freiwillige Feuerwehr OB Nienhagen' => 'Nienhagen',
      }.each do |long, short|
        expect(described_class.clean_and_cut_shortcut(long)).to eq short
      end
    end
  end
end
