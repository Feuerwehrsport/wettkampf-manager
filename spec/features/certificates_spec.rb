# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Certificates', seed: :configured do
  before do
    Presets::Nothing.new.save
  end

  it 'is available after first start', js: true do
    perform_login

    visit certificates_templates_path
    click_on 'Hinzufügen'
    fill_in 'Name', with: 'Einzelstarter'
    expect do
      click_on 'Speichern'
      expect(page).to have_content('Urkundenvorlage erfolgreich erstellt')
    end.to change(Certificates::Template, :count).by(1)

    click_on 'Textpositionen'
    within('.panel-heading') do
      expect(page).to have_content('Einzelstarter')
    end
    click_on 'Speichern'
    expect(page).to have_content(' Urkundenvorlage erfolgreich geändert')
  end
end
