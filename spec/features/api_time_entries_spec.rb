require 'rails_helper'
RSpec.describe 'API Time entries', seed: :configured do
  before do
    Preset.find(4).save # D-Cup ohne 4x100
  end
  let(:assessment) { Assessment.discipline(Disciplines::ClimbingHookLadder.first).gender(:male).first }
  let!(:result) { create :score_result, assessment: assessment }
  let!(:person1) { create :person, :generated }
  let!(:person2) { create :person, :generated }
  let!(:person3) { create :person, :generated }
  let!(:list) { create_score_list(result, person1 => :waiting, person2 => :waiting, person3 => :waiting) }

  it 'can add times to runs' do
    API::TimeEntry.create!(sender: 'Hakenleitersteigen', hint: 'Bahn 1', time: 1122, skip_password_authenticaton: true)

    perform_login
    visit root_path
    find('li.dropdown').click
    click_on 'API-Zeiten'
    within('tr', text: 'Hakenleitersteigen') do
      click_on 'Zuordnen'
    end

    expect(page).to have_content('Zeit  11,22 s')
    within('tr', text: person1.last_name) do
      click_on 'Zeit zuordnen'
    end

    expect(page).to have_css('.form-control.numeric.second_time.optional')
    expect(page).to have_content(person1.last_name)
    expect(page).to have_content(person1.first_name)
    expect(find('input.form-control.numeric.second_time.optional').value).to eq '11.22'
    click_on 'Speichern'

    expect(page).to have_content('Startlistenvorauswahl')
    API::TimeEntry.create!(sender: 'Hakenleitersteigen', hint: 'Bahn 2', time: 1222, skip_password_authenticaton: true)
    API::TimeEntry.create!(sender: 'Hakenleitersteigen', hint: 'Bahn 1', time: 1322, skip_password_authenticaton: true)
    visit api_time_entries_path

    within('tr', text: '12,22') do
      click_on 'Zuordnen'
    end

    expect(page).to have_content('Zeit  12,22 s')
    expect(page).not_to have_content(person1.last_name)
    within('tr', text: person2.last_name) do
      click_on 'Zeit zuordnen'
    end

    expect(page).to have_css('.form-control.numeric.second_time.optional')
    within('tr', text: person2.last_name) do
      choose('Ungültig')
    end
    click_on 'Speichern'

    expect(page).to have_content('Zeit  13,22 s')
    expect(page).not_to have_content(person1.last_name)
    expect(page).not_to have_content(person2.last_name)
    within('tr', text: person3.last_name) do
      click_on 'Zeit zuordnen'
    end

    API::TimeEntry.create!(sender: 'Hakenleitersteigen', hint: 'Bahn 2', time: 8022, skip_password_authenticaton: true)
    expect(page).to have_css('.form-control.numeric.second_time.optional')
    click_on 'Speichern'

    within('.panel-body', text: 'Hakenleitersteigen') do
      click_on 'Übersicht'
    end

    expect(page).to have_content('Startlistenvorauswahl')
    within('tr', text: '80,22') do
      accept_confirm do
        click_on 'Ignorieren'
      end
    end

    expect(page).to have_content('Derzeit keine Einträge vorhanden')
    expect(list.reload.entries.decorate.map(&:human_time)).to eq ['11,22', 'D', '13,22']
  end
end
