# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Teams and People', seed: :configured do
  let!(:federal_state) { create(:federal_state) }
  let!(:fire_sport_statistics_person) { create(:fire_sport_statistics_person, :with_statistics) }

  before do
    Preset.find(4).save # D-Cup ohne 4x100
  end

  it 'is available after first start', js: true do
    perform_login

    click_on 'Mannschaften'
    within(:css, '.panel-heading') { expect(page).to have_content 'Mannschaften' }

    within(:css, '.row .row', text: 'Frauen') do
      click_on 'Mannschaft hinzufügen'
    end

    within(:css, '.panel-heading') { expect(page).to have_content 'Mannschaft' }
    fill_in 'Name', with: 'FF Warin'
    select 'Mecklenburg-Vorpommern', from: 'Bundesland'
    click_on 'Speichern'

    expect(page).to have_content 'Mannschaft erfolgreich erstellt'
    expect(page).to have_content 'Keine Einträge gefunden'
    expect(page).to have_content 'Mecklenburg-Vorpommern'

    click_on 'Wertungen bearbeiten', match: :first

    within(:css, '.modal') do
      expect(page).to have_content 'Löschangriff Nass - Frauen'
      click_on 'Speichern'
    end

    click_on 'Wettkämpfer hinzufügen', match: :first

    within(:css, '.modal') do
      expect(page).to have_content 'Wettkämpfer'
      fill_in 'Schnelleingabe', with: 'Alfred Meier'
      expect(find_field('Vorname').value).to have_content 'Alfred'
      expect(find_field('Nachname').value).to have_content 'Meier'
      find('.suggestions-entries td.first_name').click
      click_on 'Speichern'
    end

    within(:css, '.modal') do
      within(:css, '.assessment-request:nth-of-type(1)') do
        expect(page).to have_content '100m Hindernisbahn - Frauen'
        check 'Teilnahme'
      end
      within(:css, '.assessment-request:nth-of-type(2)') do
        expect(page).to have_content 'Hakenleitersteigen - Frauen'
        check 'Teilnahme'
      end
      click_on 'Speichern'
    end

    expect(Person.first.fire_sport_statistics_person).to eq fire_sport_statistics_person

    click_on 'Wettkämpfer hinzufügen', match: :first

    within(:css, '.modal') do
      expect(page).to have_content 'Wettkämpfer'
      fill_in 'Schnelleingabe', with: 'Peter'
      expect(find_field('Vorname').value).to have_content 'Peter'
      expect(find_field('Nachname').value).to have_content ''
      click_on 'Speichern'
    end

    within(:css, '.modal') do
      expect(page).to have_content 'Bitte prüfen Sie die folgenden Felder:'
      expect(find_field('Vorname').value).to have_content 'Peter'
      fill_in 'Nachname', with: 'Müller'
      click_on 'Speichern'
    end

    within(:css, '.modal') do
      within(:css, '.assessment-request:nth-of-type(1)') do
        expect(page).to have_content '100m Hindernisbahn - Frauen'
        check 'Teilnahme'
        select 'Einzelstarter', from: '100m Hindernisbahn - Frauen'
      end
      within(:css, '.assessment-request:nth-of-type(2)') do
        expect(page).to have_content 'Hakenleitersteigen - Frauen'
        check 'Teilnahme'
        select 'Einzelstarter', from: 'Hakenleitersteigen - Frauen'
      end
      click_on 'Speichern'
    end

    visit team_path(Team.last)

    expect(page).to have_content 'Alfred Meier'
    expect(page).to have_content 'M1'
    expect(page).to have_content 'Peter Müller'
    expect(page).to have_content 'E1'

    assessment_requests = AssessmentRequest.where(entity_type: 'Person')
    expect(assessment_requests.assessment_type(:group_competitor)).to have(2).items
    expect(assessment_requests.assessment_type(:single_competitor)).to have(2).items

    visit people_path
    within(:css, '.row .row', text: 'Frauen') do
      click_on 'Wettkämpfer hinzufügen'
    end

    within(:css, '.modal') do
      expect(page).to have_content 'Wettkämpfer'
      fill_in 'Schnelleingabe', with: 'Wilhelm Busch'
      expect(find_field('Vorname').value).to have_content 'Wilhelm'
      expect(find_field('Nachname').value).to have_content 'Busch'
      select 'FF Warin', from: 'Mannschaft'
      click_on 'Speichern'
    end

    within(:css, '.modal') do
      within(:css, '.assessment-request:nth-of-type(1)') do
        expect(page).to have_content '100m Hindernisbahn - Frauen'
        check 'Teilnahme'
      end
      within(:css, '.assessment-request:nth-of-type(2)') do
        expect(page).to have_content 'Hakenleitersteigen - Frauen'
        check 'Teilnahme'
        fill_in 'Reihenfolge', with: '6'
      end
      click_on 'Speichern'
    end

    click_on 'Wettkämpfer hinzufügen', match: :first

    within(:css, '.modal') do
      expect(page).to have_content 'Wettkämpfer'
      fill_in 'Schnelleingabe', with: 'Karl Marx'
      expect(find_field('Vorname').value).to have_content 'Karl'
      expect(find_field('Nachname').value).to have_content 'Marx'
      click_on 'Speichern'
    end

    within(:css, '.modal') do
      within(:css, '.assessment-request:nth-of-type(1)') do
        expect(page).to have_content '100m Hindernisbahn - AK 1'
        check 'Teilnahme'
      end
      within(:css, '.assessment-request:nth-of-type(2)') do
        expect(page).to have_content 'Hakenleitersteigen - AK 1'
        check 'Teilnahme'
      end
      click_on 'Speichern'
    end

    visit people_path

    expect(page).to have_content 'Alfred Meier'
    expect(page).to have_content 'M1'
    expect(page).to have_content 'Wilhelm Busch'
    expect(page).to have_content 'M2'
    expect(page).to have_content 'M6'
    expect(page).to have_content 'Karl Marx'
    expect(page).to have_content 'M0'
    expect(page).to have_content 'Peter Müller'
    expect(page).to have_content 'E1'

    assessment_requests = AssessmentRequest.where(entity_type: 'Person')
    expect(assessment_requests.assessment_type(:group_competitor)).to have(6).items
    expect(assessment_requests.assessment_type(:single_competitor)).to have(2).items
  end
end
