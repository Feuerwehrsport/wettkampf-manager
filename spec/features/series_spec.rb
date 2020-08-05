# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Series', seed: :configured do
  before do
    cup = create(:series_cup)
    create(:series_person_participation, cup: cup)
    create(:series_team_participation, cup: cup)
    Preset.find(4).save # D-Cup ohne 4x100

    list = create(:score_list,
                  assessments: Assessment.gender(:female).discipline(Disciplines::FireAttack.new),
                  results: Score::Result.gender(:female).discipline(Disciplines::FireAttack.new),
                  name: 'Löschangriff Lauf 1')

    create(:score_list_entry, :result_valid,
           list: list,
           assessment: list.assessments.first,
           entity: create(:team, :female),
           time: 3344)
  end

  it 'is available after first start' do
    visit root_path
    click_on 'Cup-Wertung'

    expect(page).to have_content 'Mannschaftswertung Frauen'
    click_on 'Hakenleitersteigen - Männlich'
    expect(page).to have_content 'Alfred'
    expect(page).to have_content 'Meier'
  end
end
