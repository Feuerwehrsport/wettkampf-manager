# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'jump through pages', seed: :configured do
  before do
    Preset.find(1).save # nothing
  end

  it 'creates lists for most disciplines', js: true do
    visit root_path
    click_on 'Weitere Informationen'
    expect(page).to have_content('Impressum dieses Auftritts')
    click_on 'Mannschaften'
    within('.panel') { expect(page).to have_content('Mannschaften') }
    click_on 'Wettkämpfer'
    within('.panel') { expect(page).to have_content('Wettkämpfer') }
    click_on 'Startlisten'
    within('.panel') { expect(page).to have_content('Startlisten') }
    click_on 'Ergebnisse'
    within('.panel') { expect(page).to have_content('Ergebnisse') }
  end
end
