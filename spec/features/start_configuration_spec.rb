require 'rails_helper'
RSpec.feature "Start configuration" do
  it "is available after first start" do

    visit root_path
    expect(page).to have_content "Passwort für Systemanmeldung"
    fill_in "Passwort", with: "my-password"
    fill_in "Passwort wiederholen", with: "my-password"
    click_on "Passwort ändern"
    
    expect(page).to have_content "Wettkampf-Manager konfigurieren"
    within(:css, "table.table") do
      click_on 'Ansehen', match: :first
    end

    expect(page).to have_content "Deutschland-Cup (HL, HB, GS, LA)"
    click_on 'Ausführen'

    expect(page).to have_content "Vorgang erfolgreich durchgeführt"

    visit root_path
    expect(page).to have_content "Flyer anzeigen"
  end
end
