require 'rails_helper'
RSpec.describe 'Imports', seed: :configured do
  before do
    Preset.find(3).save # D-Cup mit 4x100
  end

  it 'imports' do
    expect(Tag.count).to eq 1
    expect(Team.count).to eq 0
    expect(TagReference.count).to eq 6
    expect(AssessmentRequest.count).to eq 0
    expect(Person.count).to eq 0

    perform_login

    visit root_path
    click_on 'Import von Feuerwehrsport-Statistik.de'

    expect(page).to have_content 'Importkonfiguration'
    attach_file('Import-Datei', Rails.root.join('spec/fixtures/import.wettkampf_manager_import'))
    click_on 'Speichern'
    expect(page).to have_content 'Importkonfiguration erfolgreich erstellt'
    click_on 'Weiter'
    accept_confirm do
      click_on 'Importieren'
    end
    expect(page).to have_content 'Import wurde durchgeführt'

    expect(Tag.count).to eq 3
    expect(Team.count).to eq 3
    expect(TagReference.count).to eq 9
    expect(AssessmentRequest.count).to eq 12
    expect(Person.count).to eq 4
  end
end
