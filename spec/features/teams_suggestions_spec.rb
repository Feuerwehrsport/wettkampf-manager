require 'rails_helper'
RSpec.describe 'Teams and People', seed: :configured do
  let!(:team) { create(:team, name: 'Mecklenburg') }
  let!(:fire_sport_statistics_team) { create(:fire_sport_statistics_team) }
  let!(:fire_sport_statistics_team_other) { create(:fire_sport_statistics_team, name: 'Mecklenburg Vorpommern') }

  let!(:team_warin) { create(:team, name: 'Warin') }
  let!(:fire_sport_statistics_team_warin) { create(:fire_sport_statistics_team, name: 'Warin') }

  before do
    Preset.find(4).save # D-Cup ohne 4x100
  end
  it 'is available after first start', js: true do
    allow(Series::Round).to receive(:with_local_results).and_return(1)

    perform_login

    click_on 'Mannschaften'
    expect(page).to have_content('keine Serien-Ergebnisse gefunden wu')
    click_on 'Probleme ansehen'
    expect(page).to have_content('Bei folgenden Einträgen konnten keine Serien-Ergebnisse zugeordnet werden.')
    click_on 'Vorschlag auswählen'
    find('.suggestions-entries td', text: 'Mecklenburg-Vorpommern').click
    click_on 'Speichern'
    sleep 0.1

    click_on 'Mannschaften'
    expect(page).to have_content('keine Serien-Ergebnisse gefunden wu')
    click_on 'Probleme ansehen'
    expect(page).to have_content('Bei folgenden Einträgen konnten keine Serien-Ergebnisse zugeordnet werden.')
    click_on 'Übernehmen'
    sleep 0.1
    click_on 'Mannschaften'
    expect(page).not_to have_content('keine Serien-Ergebnisse gefunden wu')

    expect(Team.first.fire_sport_statistics_team).to eq fire_sport_statistics_team
  end
end
