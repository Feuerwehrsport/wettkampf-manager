# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'list factory', seed: :configured do
  before do
    Preset.find(3).save # D-Cup mit 4x100
  end

  let(:team1) { create(:team, :generated) }
  let(:team2) { create(:team, :generated) }
  let(:person1) { create(:person, team: team1) }
  let(:person2) { create(:person, team: team1) }
  let(:assessment) { Assessment.requestable_for(person1).first }
  let(:assessment_request1) do
    create(:assessment_request, entity: person1, assessment: assessment, group_competitor_order: 1)
  end
  let(:assessment_request2) do
    create(:assessment_request, entity: person2, assessment: assessment, group_competitor_order: 2)
  end
  let(:result) { Score::Result.where(assessment: assessment).first }

  let(:fire_relay_assessment) { Assessment.all.to_a.find { |a| a.discipline.like_fire_relay? } }
  let(:assessment_request_fire_relay1) do
    create(:assessment_request, entity: team1, assessment: fire_relay_assessment, relay_count: 2)
  end
  let(:assessment_request_fire_relay2) do
    create(:assessment_request, entity: team2, assessment: fire_relay_assessment, relay_count: 1)
  end

  it 'creates lists for most disciplines', js: true do
    assessment_request1
    assessment_request2

    perform_login
    visit score_lists_path

    click_on 'Hinzufügen', match: :first
    click_on '100m Hindernisbahn'
    check '100m Hindernisbahn - Männer (2 Starter)'
    click_on 'Weiter'
    expect(find_field('Name').value).to eq '100m Hindernisbahn - Männer - Lauf 1'
    expect(find_field('Abkürzung').value).to eq 'Lauf 1'
    click_on 'Weiter'
    expect(find_field('Wettkampfbahnen').value).to eq '2'
    click_on 'Weiter'
    expect(find_field('100m Hindernisbahn - Männer')).to be_checked
    expect(find_field('100m Hindernisbahn - Männer - U20')).to be_checked
    click_on 'Weiter'
    expect(find_field('Mannschaftsreihenfolge beachten')).to be_checked
    click_on 'Weiter'
    choose 'Einzelstarter vor Mannschaftsstarter'
    click_on 'Weiter'
    expect(page).to have_content('Voraussichtliche Liste')
    click_on 'Startliste erstellen'

    within('.panel-heading', match: :first) do
      expect(page).to have_content('100m Hindernisbahn - Männer - Lauf 1')
    end

    expect(Score::List.last.entries.count).to eq 2
    expect(Score::List.last.entries.where(entity: person1).first.track).to eq 1
    expect(Score::List.last.entries.where(entity: person2).first.track).to eq 2

    # Zeiten im Block eintragen
    click_on('Zeiten im Block eintragen')

    within(page.all('td.edit-time')[0]) do
      choose 'Gültig'
      fill_in('Zeit in Sekunden', with: '19.99')
    end

    within(page.all('td.edit-time')[1]) do
      choose 'Gültig'
      fill_in('Zeit in Sekunden', with: '17.11')
    end
    click_on('Speicher')

    # Lauf 2

    click_on 'Startlisten'
    click_on 'Hinzufügen', match: :first
    click_on '100m Hindernisbahn'
    check '100m Hindernisbahn - Männer (2 Starter)'
    click_on 'Weiter'
    expect(find_field('Name').value).to eq '100m Hindernisbahn - Männer - Lauf 2'
    expect(find_field('Abkürzung').value).to eq 'Lauf 2'
    click_on 'Weiter'
    expect(find_field('Wettkampfbahnen').value).to eq '2'
    click_on 'Weiter'
    expect(find_field('100m Hindernisbahn - Männer')).to be_checked
    expect(find_field('100m Hindernisbahn - Männer - U20')).to be_checked
    click_on 'Weiter'
    expect(find_field('Mannschaftsreihenfolge beachten')).to be_checked
    choose 'Bahnwechsel'
    click_on 'Weiter'
    expect(find_field('Vorherige Liste').value).to eq Score::List.last.id.to_s
    click_on 'Weiter'
    expect(page).to have_content('Voraussichtliche Liste')
    click_on 'Startliste erstellen'

    within('.panel-heading', match: :first) do
      expect(page).to have_content('100m Hindernisbahn - Männer - Lauf 2')
    end

    expect(Score::List.last.entries.count).to eq 2
    expect(Score::List.last.entries.where(entity: person1).first.track).to eq 2
    expect(Score::List.last.entries.where(entity: person2).first.track).to eq 1

    # Lauf 3

    click_on 'Startlisten'
    click_on 'Hinzufügen', match: :first
    click_on '100m Hindernisbahn'
    check '100m Hindernisbahn - Männer (2 Starter)'
    click_on 'Weiter'
    expect(find_field('Name').value).to eq '100m Hindernisbahn - Männer - Lauf 3'
    expect(find_field('Abkürzung').value).to eq 'Lauf 3'
    click_on 'Weiter'
    expect(find_field('Wettkampfbahnen').value).to eq '2'
    click_on 'Weiter'
    expect(find_field('100m Hindernisbahn - Männer')).to be_checked
    expect(find_field('100m Hindernisbahn - Männer - U20')).to be_checked
    click_on 'Weiter'
    expect(find_field('Mannschaftsreihenfolge beachten')).to be_checked
    choose 'Bahn behalten'
    click_on 'Weiter'
    select('100m Hindernisbahn - Männer - Lauf 2', from: 'Vorherige Liste')
    click_on 'Weiter'
    expect(page).to have_content('Voraussichtliche Liste')
    click_on 'Startliste erstellen'

    within('.panel-heading', match: :first) do
      expect(page).to have_content('100m Hindernisbahn - Männer - Lauf 3')
    end

    expect(Score::List.last.entries.count).to eq 2
    expect(Score::List.last.entries.where(entity: person1).first.track).to eq 2
    expect(Score::List.last.entries.where(entity: person2).first.track).to eq 1

    # Lauf 4

    click_on 'Startlisten'
    click_on 'Hinzufügen', match: :first
    click_on '100m Hindernisbahn'
    check '100m Hindernisbahn - Männer (2 Starter)'
    click_on 'Weiter'
    expect(find_field('Name').value).to eq '100m Hindernisbahn - Männer - Lauf 4'
    expect(find_field('Abkürzung').value).to eq 'Lauf 4'
    click_on 'Weiter'
    expect(find_field('Wettkampfbahnen').value).to eq '2'
    click_on 'Weiter'
    expect(find_field('100m Hindernisbahn - Männer')).to be_checked
    expect(find_field('100m Hindernisbahn - Männer - U20')).to be_checked
    click_on 'Weiter'
    expect(find_field('Mannschaftsreihenfolge beachten')).to be_checked
    choose 'Zufällig anordnen'
    click_on 'Weiter'
    expect(page).to have_content('Voraussichtliche Liste')
    click_on 'Startliste erstellen'

    within('.panel-heading', match: :first) do
      expect(page).to have_content('100m Hindernisbahn - Männer - Lauf 4')
    end

    expect(Score::List.last.entries.count).to eq 2
    expect(Score::List.last.entries.map(&:track)).to match_array [1, 2]

    # Lauf 5

    click_on 'Startlisten'
    click_on 'Hinzufügen', match: :first
    click_on '100m Hindernisbahn'
    check '100m Hindernisbahn - Männer (2 Starter)'
    click_on 'Weiter'
    expect(find_field('Name').value).to eq '100m Hindernisbahn - Männer - Lauf 5'
    expect(find_field('Abkürzung').value).to eq 'Lauf 5'
    click_on 'Weiter'
    expect(find_field('Wettkampfbahnen').value).to eq '2'
    click_on 'Weiter'
    expect(find_field('100m Hindernisbahn - Männer')).to be_checked
    expect(find_field('100m Hindernisbahn - Männer - U20')).to be_checked
    click_on 'Weiter'
    expect(find_field('Mannschaftsreihenfolge beachten')).to be_checked
    choose 'die x Besten (Finale)'
    click_on 'Weiter'
    select('100m Hindernisbahn - Männer', from: 'Ergebnisliste')
    fill_in('Anzahl der Finalisten auf der neuen Liste (X)', with: '1')
    click_on 'Weiter'
    expect(page).to have_content('Voraussichtliche Liste')
    click_on 'Startliste erstellen'

    within('.panel-heading', match: :first) do
      expect(page).to have_content('100m Hindernisbahn - Männer - Lauf 5')
    end

    expect(Score::List.last.entries.count).to eq 1
    expect(Score::List.last.entries.first.track).to eq 1
    expect(Score::List.last.entries.first.entity).to eq person2
  end

  it 'creates lists for fire relay', js: true do
    assessment_request_fire_relay1
    assessment_request_fire_relay2

    perform_login
    visit root_path

    click_on 'Startlisten'
    click_on 'Hinzufügen', match: :first
    click_on '4x100m Feuerwehrstafette'
    check '4x100m Feuerwehrstafette - Frauen (2x A, 1x B)'
    click_on 'Weiter'
    expect(find_field('Name').value).to eq '4x100m Feuerwehrstafette - Frauen'
    expect(find_field('Abkürzung').value).to eq 'Lauf'
    click_on 'Weiter'
    expect(find_field('Wettkampfbahnen').value).to eq '2'
    click_on 'Weiter'
    expect(find_field('4x100m Feuerwehrstafette - Frauen')).to be_checked
    click_on 'Weiter'
    expect(find_field('Staffellauf mit A, B')).to be_checked
    click_on 'Weiter'
    expect(page).to have_content('Voraussichtliche Liste')
    click_on 'Startliste erstellen'

    within('.panel-heading', match: :first) do
      expect(page).to have_content('4x100m Feuerwehrstafette - Frauen')
    end

    expect(Score::List.last.entries.count).to eq 3
    expect(Score::List.last.entries.map(&:track)).to match_array [1, 1, 2]
  end
end
