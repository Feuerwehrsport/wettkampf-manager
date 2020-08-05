# frozen_string_literal: true

FactoryBot.define do
  factory :series_cup, class: 'Series::Cup' do
    round { Series::Round.first || build(:series_round) }
    competition_date { Date.parse('2018-01-01') }
    competition_place { 'Rostock' }
  end
end
