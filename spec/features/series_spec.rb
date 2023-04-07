# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Series', seed: :configured do
  before do
    cup = create(:series_cup)
    create(:series_person_participation, cup: cup)
    create(:series_team_participation, cup: cup)
    Preset.find(4).save # D-Cup ohne 4x100

    list = create(:score_list,
                  assessments: Assessment.discipline(Disciplines::FireAttack.new),
                  results: Score::Result.discipline(Disciplines::FireAttack.new),
                  name: 'Löschangriff Lauf 1')

    create(:score_list_entry, :result_valid,
           list: list,
           assessment: list.assessments.first,
           entity: create(:team, :female),
           time: 3344)

    hl_round = create(:series_round, name: 'Steigercup')
    create(:series_cup, round: hl_round)
    hl_assessment = create(:series_person_assessment, round: hl_round)

    r = Score::Result.where(assessment:
      Assessment.where(discipline: Discipline.instance_for_key(:hl), band: Band.where(name: 'Frauen'))).first
    r.series_assessments.push(hl_assessment)
  end

  it 'is available after first start' do
    visit root_path
    click_on 'Cup-Wertung'
    expect(page).to have_content 'Wettkampfserien'
    expect(page).to have_content 'Steigercup'

    click_on 'D-Cup'
    expect(page).to have_content 'Mannschaftswertung weiblich'
    expect(page).not_to have_content 'Steigercup'

    click_on 'Hakenleitersteigen - Männlich'
    expect(page).to have_content 'Alfred'
    expect(page).to have_content 'Meier'
  end
end
