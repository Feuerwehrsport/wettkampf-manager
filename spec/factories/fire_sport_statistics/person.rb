# frozen_string_literal: true

FactoryBot.define do
  factory :fire_sport_statistics_person, class: 'FireSportStatistics::Person' do
    first_name { 'Alfred' }
    last_name { 'Meier' }
    gender { :male }

    trait :with_statistics do
      personal_best_hb { 2022 }
      personal_best_hb_competition { 'Wettkampf 1' }
      personal_best_hl { 1922 }
      personal_best_hl_competition { 'Wettkampf 2' }
      personal_best_zk { 4022 }
      personal_best_zk_competition { 'Wettkampf 3' }
      saison_best_hb { 2023 }
      saison_best_hb_competition { 'Wettkampf 4' }
      saison_best_hl { 1923 }
      saison_best_hl_competition { 'Wettkampf 5' }
      saison_best_zk { 4023 }
      saison_best_zk_competition { 'Wettkampf 6' }
    end
  end
end
