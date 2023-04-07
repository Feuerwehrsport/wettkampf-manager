# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'score lists', seed: :configured do
  before do
    Preset.find(1).save # nothing
  end

  let(:band) { create(:band, :male) }

  context 'when entity is a person' do
    let(:assessment) { create(:assessment, band: band) }
    let!(:result) { create :score_result, assessment: assessment }
    let!(:person1) { create :person, :generated, band: band }
    let!(:person2) { create :person, :generated, band: band }
    let!(:person3) { create :person, :generated, band: band }
    let!(:person4) { create :person, :generated, band: band }
    let!(:list) { create_score_list(result, person1 => :waiting, person2 => :waiting, person3 => :waiting) }

    it 'tests some features', js: true do
      perform_login
      visit score_list_path(list)
      expect(page).to have_content('Hakenleitersteigen - Männer - Lauf 1')
      within('tr', text: person1.last_name) do
        find('a[title="Zeiten bearbeiten"]').click
      end

      expect(page).to have_content('Hakenleitersteigen - Männer - Lauf 1 (Lauf 1)')
      within('tr', text: person1.last_name) do
        fill_in('Zeit in Sekunden', with: '21.23')
      end
      within('tr', text: person2.last_name) do
        fill_in('Zeit in Sekunden', with: '32.34')
      end
      click_on('Speichern')

      expect(page).to have_content('Hakenleitersteigen - Männer - Lauf 1')
      within('tr', text: person2.last_name) do
        expect(page).to have_content('32,34')
      end
      within('tr', text: person1.last_name) do
        expect(page).to have_content('21,23')
        find('a[title="Zeiten bearbeiten"]').click
      end

      expect(page).to have_content('Hakenleitersteigen - Männer - Lauf 1 (Lauf 1)')
      within('tr', text: person1.last_name) do
        choose('Ungültig')
      end
      click_on('Speichern')

      expect(page).to have_content('Hakenleitersteigen - Männer - Lauf 1')
      within('tr', text: person1.last_name) do
        expect(page).to have_content('D')
      end
      click_on('Teilnehmer hinzufügen')

      expect(list.reload.entries.count).to eq 3

      within('.modal.panel') do
        expect(page).to have_content('Teilnehmer hinzufügen')
        find(".score_list_entries_entity option[value='#{person4.id}']").select_option
        select('Hakenleitersteigen - Männer', from: 'Wertung/Gruppe')
        click_on('Hinzufügen')
      end

      expect(page).not_to have_css('.modal.panel')
      visit score_list_path(list)

      click_on('Zeiten im Block eintragen')
      expect(page).to have_css('.simple_form.edit_score_list')
      within('tr', text: person4.last_name) do
        fill_in('Zeit in Sekunden', with: '33.33')
      end
      click_on('Speichern')
      expect(page).not_to have_css('.simple_form.edit_score_list')

      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['D', '32,34', '', '33,33']

      click_on('Reihenfolge bearbeiten')

      expect(page).to have_content('Einfach die Zeilen in die neue Position ziehen')
      within('tr', text: person4.last_name) do
        find('div[title="Ganz nach oben"]').click
      end
      click_on('Liste speichern')
      click_on('Ansehen')
      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['33,33', 'D', '32,34', '']
      expect(page).not_to have_content('Einfach die Zeilen in die neue Position ziehen')

      click_on('Teilnehmer entfernen')
      within('tr', text: person4.last_name) do
        expect(page).to have_content(person4.first_name)
        expect(list.reload.entries.count).to eq 4
        expect(list.reload.entries.last.track).to eq 2
        find('a[title="Aus Liste entfernen"]').click
      end

      within('.modal.panel') do
        expect(page).to have_content('Teilnehmer aus Liste entfernen')
        click_on('Entfernen')
      end

      expect(page).not_to have_css('.modal.panel')
      visit score_list_path(list)

      expect(list.reload.entries.count).to eq 3
      expect(page).not_to have_content(person4.last_name)
      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['D', '32,34', '']
    end
  end

  context 'when entity is a team' do
    let(:assessment) { create(:assessment, :fire_attack, band: band) }
    let!(:result) { create :score_result, assessment: assessment }
    let!(:team1) { create :team, :generated, band: band }
    let!(:team2) { create :team, :generated, band: band }
    let!(:team3) { create :team, :generated, band: band }
    let!(:team4) { create :team, :generated, band: band }
    let!(:list) do
      create_score_list(result, team1 => :waiting, team2 => :waiting, team3 => :waiting).tap do |list|
        list.update!(name: 'LA')
      end
    end

    it 'tests some features', js: true do
      perform_login
      visit score_list_path(list)
      expect(page).to have_content('LA')
      within('tr', text: team1.name) do
        find('a[title="Zeiten bearbeiten"]').click
      end

      expect(page).to have_content('LA (Lauf 1)')
      within('tr', text: team1.name) do
        fill_in('Zeit in Sekunden', with: '21.23')
      end
      within('tr', text: team2.name) do
        fill_in('Zeit in Sekunden', with: '32.34')
      end
      click_on('Speichern')

      expect(page).to have_content('LA')
      within('tr', text: team2.name) do
        expect(page).to have_content('32,34')
      end
      within('tr', text: team1.name) do
        expect(page).to have_content('21,23')
        find('a[title="Zeiten bearbeiten"]').click
      end

      expect(page).to have_content('LA (Lauf 1)')
      within('tr', text: team1.name) do
        choose('Ungültig')
      end
      click_on('Speichern')

      expect(page).to have_content('LA')
      within('tr', text: team1.name) do
        expect(page).to have_content('D')
      end
      click_on('Teilnehmer hinzufügen')

      expect(list.reload.entries.count).to eq 3

      within('.modal.panel') do
        expect(page).to have_content('Teilnehmer hinzufügen')
        find(".score_list_entries_entity option[value='#{team4.id}']").select_option
        select('Löschangriff Nass - Männer', from: 'Wertung/Gruppe')
        click_on('Hinzufügen')
      end

      expect(page).not_to have_css('.modal.panel')
      visit score_list_path(list)

      click_on('Zeiten im Block eintragen')
      expect(page).to have_css('.simple_form.edit_score_list')
      within('tr', text: team4.name) do
        fill_in('Zeit in Sekunden', with: '33.33')
      end
      click_on('Speichern')
      expect(page).not_to have_css('.simple_form.edit_score_list')

      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['D', '32,34', '', '33,33']

      click_on('Reihenfolge bearbeiten')

      expect(page).to have_content('Einfach die Zeilen in die neue Position ziehen')
      within('tr', text: team4.name) do
        find('div[title="Ganz nach oben"]').click
      end
      click_on('Liste speichern')
      click_on('Ansehen')
      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['33,33', 'D', '32,34', '']
      expect(page).not_to have_content('Einfach die Zeilen in die neue Position ziehen')

      click_on('Teilnehmer entfernen')
      within('tr', text: team4.name) do
        expect(list.reload.entries.count).to eq 4
        expect(list.reload.entries.last.track).to eq 2
        find('a[title="Aus Liste entfernen"]').click
      end

      within('.modal.panel') do
        expect(page).to have_content('Teilnehmer aus Liste entfernen')
        click_on('Entfernen')
      end

      expect(page).not_to have_css('.modal.panel')
      visit score_list_path(list)

      expect(list.reload.entries.count).to eq 3
      expect(page).not_to have_content(team4.name)
      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['D', '32,34', '']
    end
  end

  context 'when entity is a team_relay' do
    let(:assessment) { create(:assessment, :fire_relay, band: band) }
    let!(:result) { create :score_result, assessment: assessment }
    let!(:team1) { create :team, :generated, band: band }
    let!(:team2) { create :team, :generated, band: band }
    let!(:team_relay1) { create :team_relay, team: team1, number: 1 }
    let!(:team_relay2) { create :team_relay, team: team1, number: 2 }
    let!(:team_relay3) { create :team_relay, team: team2, number: 1 }
    let!(:team_relay4) { create :team_relay, team: team2, number: 2 }
    let!(:list) do
      create_score_list(result, team_relay1 => :waiting, team_relay2 => :waiting, team_relay3 => :waiting).tap do |list|
        list.update!(name: 'FS')
      end
    end

    it 'tests some features', js: true do
      perform_login
      visit score_list_path(list)
      expect(page).to have_content('FS')
      within('tr', text: team_relay1.decorate.to_s) do
        find('a[title="Zeiten bearbeiten"]').click
      end

      expect(page).to have_content('FS (Lauf 1)')
      within('tr', text: team_relay1.decorate.to_s) do
        fill_in('Zeit in Sekunden', with: '21.23')
      end
      within('tr', text: team_relay2.decorate.to_s) do
        fill_in('Zeit in Sekunden', with: '32.34')
      end
      click_on('Speichern')

      expect(page).to have_content('FS')
      within('tr', text: team_relay2.decorate.to_s) do
        expect(page).to have_content('32,34')
      end
      within('tr', text: team_relay1.decorate.to_s) do
        expect(page).to have_content('21,23')
        find('a[title="Zeiten bearbeiten"]').click
      end

      expect(page).to have_content('FS (Lauf 1)')
      within('tr', text: team_relay1.decorate.to_s) do
        choose('Ungültig')
      end
      click_on('Speichern')

      expect(page).to have_content('FS')
      within('tr', text: team_relay1.decorate.to_s) do
        expect(page).to have_content('D')
      end
      click_on('Teilnehmer hinzufügen')

      expect(list.reload.entries.count).to eq 3

      within('.modal.panel') do
        expect(page).to have_content('Teilnehmer hinzufügen')
        find(".score_list_entries_entity option[value='#{team_relay4.id}']").select_option
        select('Feuerwehrstafette - Männer', from: 'Wertung/Gruppe')
        click_on('Hinzufügen')
      end

      expect(page).not_to have_css('.modal.panel')
      visit score_list_path(list)

      click_on('Zeiten im Block eintragen')
      expect(page).to have_css('.simple_form.edit_score_list')
      within('tr', text: team_relay4.decorate.to_s) do
        fill_in('Zeit in Sekunden', with: '33.33')
      end
      click_on('Speichern')
      expect(page).not_to have_css('.simple_form.edit_score_list')

      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['D', '32,34', '', '33,33']

      click_on('Reihenfolge bearbeiten')

      expect(page).to have_content('Einfach die Zeilen in die neue Position ziehen')
      within('tr', text: team_relay4.decorate.to_s) do
        find('div[title="Ganz nach oben"]').click
      end
      click_on('Liste speichern')
      click_on('Ansehen')
      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['33,33', 'D', '32,34', '']
      expect(page).not_to have_content('Einfach die Zeilen in die neue Position ziehen')

      click_on('Teilnehmer entfernen')
      within('tr', text: team_relay4.decorate.to_s) do
        expect(list.reload.entries.count).to eq 4
        expect(list.reload.entries.last.track).to eq 2
        find('a[title="Aus Liste entfernen"]').click
      end

      within('.modal.panel') do
        expect(page).to have_content('Teilnehmer aus Liste entfernen')
        click_on('Entfernen')
      end

      expect(page).not_to have_css('.modal.panel')
      visit score_list_path(list)

      expect(list.reload.entries.count).to eq 3
      expect(page).not_to have_content(team_relay4.decorate.to_s)
      expect(list.reload.entries.decorate.map(&:human_time)).to eq ['D', '32,34', '']
    end
  end
end
