# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deletion of things', seed: :configured do
  before do
    Preset.find(4).save # D-Cup ohne 4x100
    assessment_request
    score_list
    list_entry = Score::ListEntry.first
    list_entry.update(result_type: :valid, time: 2222)
  end

  let(:team) { create(:team) }
  let(:person) { create(:person, team: team) }
  let(:assessment) { Assessment.requestable_for(person).first }
  let(:assessment_request) { create(:assessment_request, entity: person, assessment: assessment) }
  let(:result) { Score::Result.where(assessment: assessment).first }
  let(:score_list) do
    factory = create(:score_list_factory_simple, assessments: [assessment], results: [result])
    factory.list
    factory.perform
    factory.list
  end

  it 'is available after first start', js: true do
    perform_login

    visit score_result_path(result)
    click_on 'Löschen'
    page.driver.browser.accept_confirm
    expect(page).to have_content 'Ergebnisse erfolgreich entfernt'

    expect do
      visit score_list_path(score_list)
      click_on 'Löschen'
      page.driver.browser.accept_confirm
      expect(page).to have_content 'Startliste erfolgreich entfernt'
    end.to change(Score::ListEntry, :count).by(-1)

    visit team_path(team)
    click_on 'Löschen'
    page.driver.browser.accept_confirm
    expect(page).to have_content 'Mannschaft erfolgreich entfernt'
    expect(person.reload.team).to be_nil

    visit person_path(person)
    click_on 'Löschen'
    page.driver.browser.accept_confirm
    expect(page).to have_content 'Wettkämpfer erfolgreich entfernt'

    visit assessment_path(assessment)
    click_on 'Löschen'
    page.driver.browser.accept_confirm
    expect(page).to have_content 'Wertungsgruppe konnte nicht entfernt werden'

    visit discipline_path(assessment.discipline)
    expect(page).to have_content 'Diese Disziplin kann nicht gelöscht werden'

    Score::Result.destroy_all

    visit assessment_path(assessment)
    click_on 'Löschen'
    page.driver.browser.accept_confirm
    expect(page).to have_content 'Wertungsgruppe erfolgreich entfernt'

    visit discipline_path(assessment.discipline)
    click_on 'Ansehen'
    click_on 'Löschen'
    page.driver.browser.accept_confirm
    expect(page).to have_content 'Wertungsgruppe erfolgreich entfernt'

    visit discipline_path(assessment.discipline)
    click_on 'Löschen'
    page.driver.browser.accept_confirm
    expect(page).to have_content 'Disziplin erfolgreich entfernt'
  end
end
