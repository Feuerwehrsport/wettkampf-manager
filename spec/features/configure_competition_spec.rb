require 'rails_helper'
RSpec.describe 'configure competition', seed: :configured do
  before do
    Preset.find(1).save # nothing
  end
  it 'can add and remove tags' do
    perform_login
    visit edit_competitions_path

    within '#person_tags' do
      click_on 'Neue Markierung'
      expect(page).to have_content 'Name'
      fill_in 'Name', with: 'Ü80'
    end
    click_on 'Speichern'
    click_on 'Bearbeiten'

    within '#person_tags' do
      expect(page).to have_content 'Name'
      expect(find_field('Name').value).to eq 'Ü80'
      click_on 'Markierung entfernen'
      expect(page).not_to have_content 'Name'

      click_on 'Neue Markierung'
      expect(page).to have_content 'Name'
      click_on 'Markierung entfernen'
      expect(page).not_to have_content 'Name'
    end
  end
end
