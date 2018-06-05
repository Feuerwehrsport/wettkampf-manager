FactoryBot.define do
  factory :fire_sport_statistics_person, class: FireSportStatistics::Person do
    first_name 'Alfred'
    last_name 'Meier'
    gender :male
  end
end
