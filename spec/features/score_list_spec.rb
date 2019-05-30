require 'rails_helper'
RSpec.describe 'score lists', seed: :configured do
  before do
    Preset.find(4).save # D-Cup ohne 4x100
  end

  let(:assessment) { Assessment.discipline(Disciplines::ClimbingHookLadder.first).gender(:male).first }
  let!(:result) { create :score_result, assessment: assessment }
  let!(:person1) { create :person, :generated }
  let!(:person2) { create :person, :generated }
  let!(:person3) { create :person, :generated }
  let!(:person4) { create :person, :generated }
  let!(:list) { create_score_list(result, person1 => :waiting, person2 => :waiting, person3 => :waiting) }

  it 'creates lists for most disciplines', js: true do
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
      select('Hakenleitersteigen - Männer', from: 'Wertungsgruppe')
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
