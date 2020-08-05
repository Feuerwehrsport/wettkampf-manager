# frozen_string_literal: true

FactoryBot.define do
  factory :series_round, class: 'Series::Round' do
    name { 'D-Cup' }
    year { Date.current.year }
    aggregate_type { 'DCup' }
  end
end
