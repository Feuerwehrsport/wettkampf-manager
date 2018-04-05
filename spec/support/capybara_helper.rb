def perform_login(password = 'admin')
  visit root_path
  click_on 'Anmelden'
  expect(page).to have_content 'Anmeldung im System'
  fill_in 'Passwort', with: password
  click_on 'Anmelden'
  expect(page).to have_content 'Anmeldung erfolgreich'
end
