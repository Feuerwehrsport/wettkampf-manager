require 'rails_helper'
RSpec.feature "Teams and People" do
  before do
    User.first.update_attributes!(password: "my-password", password_confirmation: "my-password")
    CompetitionSeed.all.first.execute
  end
  it "is available after first start", js: true do
    perform_login

    click_on 'Mannschaften'
    within(:css, "h2") { expect(page).to have_content "Mannschaften" }
    click_on 'Hinzufügen', match: :first

    within(:css, "h2") { expect(page).to have_content "Mannschaft" }
    fill_in "Name", with: "FF Warin"
    select 'Männlich', from: 'Geschlecht'
    click_on "Speichern"

    expect(page).to have_content "Mannschaft erfolgreich erstellt"
    expect(page).to have_content "Keine Einträge gefunden"
    click_on "Wettkämpfer hinzufügen"

    within(:css, ".modal.box") do
      expect(page).to have_content "Wettkämpfer"
      fill_in "Schnelleingabe", with: "Alfred Meier"
      expect(find_field('Vorname').value).to have_content "Alfred"
      expect(find_field('Nachname').value).to have_content "Meier"
      select 'Männlich', from: 'Geschlecht'
      click_on "Speichern"
    end

    within(:css, ".modal.box") do
      within(:css, ".assessment-request:nth-of-type(1)") do
        expect(page).to have_content "100m Hindernisbahn - männlich"
        check 'Teilnahme'
      end
      within(:css, ".assessment-request:nth-of-type(2)") do
        expect(page).to have_content "Hakenleitersteigen - männlich"
        check 'Teilnahme'
      end
      click_on "Speichern"
    end

    click_on "Wettkämpfer hinzufügen"

    within(:css, ".modal.box") do
      expect(page).to have_content "Wettkämpfer"
      fill_in "Schnelleingabe", with: "Peter"
      expect(find_field('Vorname').value).to have_content "Peter"
      expect(find_field('Nachname').value).to have_content ""
      select 'Männlich', from: 'Geschlecht'
      click_on "Speichern"
    end

    within(:css, ".modal.box") do
      expect(page).to have_content "Bitte prüfen Sie die folgenden Felder:"
      expect(find_field('Vorname').value).to have_content "Peter"
      fill_in "Nachname", with: "Müller"
      select 'Männlich', from: 'Geschlecht'
      click_on "Speichern"
    end

    within(:css, ".modal.box") do
      within(:css, ".assessment-request:nth-of-type(1)") do
        expect(page).to have_content "100m Hindernisbahn - männlich"
        check 'Teilnahme'
        select "Einzelstarter", from: "100m Hindernisbahn - männlich"
      end
      within(:css, ".assessment-request:nth-of-type(2)") do
        expect(page).to have_content "Hakenleitersteigen - männlich"
        check 'Teilnahme'
        select "Einzelstarter", from: "Hakenleitersteigen - männlich"
      end
      click_on "Speichern"
    end
    expect(page).to have_content "Alfred Meier"
    expect(page).to have_content "M1"
    expect(page).to have_content "Peter Müller"
    expect(page).to have_content "E1"

    assessment_requests = AssessmentRequest.where(entity_type: "Person")
    expect(assessment_requests.assessment_type(:group_competitor)).to have(2).items
    expect(assessment_requests.assessment_type(:single_competitor)).to have(2).items

    visit people_path
    click_on 'Hinzufügen', match: :first

    within(:css, ".modal.box") do
      expect(page).to have_content "Wettkämpfer"
      fill_in "Schnelleingabe", with: "Wilhelm Busch"
      expect(find_field('Vorname').value).to have_content "Wilhelm"
      expect(find_field('Nachname').value).to have_content "Busch"
      select 'Männlich', from: 'Geschlecht'
      select 'FF Warin', from: 'Mannschaft'
      click_on "Speichern"
    end

    within(:css, ".modal.box") do
      within(:css, ".assessment-request:nth-of-type(1)") do
        expect(page).to have_content "100m Hindernisbahn - männlich"
        check 'Teilnahme'
      end
      within(:css, ".assessment-request:nth-of-type(2)") do
        expect(page).to have_content "Hakenleitersteigen - männlich"
        check 'Teilnahme'
      end
      click_on "Speichern"
    end

    click_on 'Hinzufügen', match: :first

    within(:css, ".modal.box") do
      expect(page).to have_content "Wettkämpfer"
      fill_in "Schnelleingabe", with: "Karl Marx"
      expect(find_field('Vorname').value).to have_content "Karl"
      expect(find_field('Nachname').value).to have_content "Marx"
      select 'Männlich', from: 'Geschlecht'
      click_on "Speichern"
    end

    within(:css, ".modal.box") do
      within(:css, ".assessment-request:nth-of-type(1)") do
        expect(page).to have_content "100m Hindernisbahn - männlich"
        check 'Teilnahme'
      end
      within(:css, ".assessment-request:nth-of-type(2)") do
        expect(page).to have_content "Hakenleitersteigen - männlich"
        check 'Teilnahme'
      end
      click_on "Speichern"
    end

    expect(page).to have_content "Alfred Meier"
    expect(page).to have_content "M1"
    expect(page).to have_content "Wilhelm Busch"
    expect(page).to have_content "M2"
    expect(page).to have_content "Karl Marx"
    expect(page).to have_content "M0"
    expect(page).to have_content "Peter Müller"
    expect(page).to have_content "E1"

    assessment_requests = AssessmentRequest.where(entity_type: "Person")
    expect(assessment_requests.assessment_type(:group_competitor)).to have(6).items
    expect(assessment_requests.assessment_type(:single_competitor)).to have(2).items
  end
end
