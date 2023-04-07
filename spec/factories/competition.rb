# frozen_string_literal: true

FactoryBot.define do
  factory :competition do
    name  { 'Wettkampf' }
    date  { Date.current }
    place { 'Bargeshagen' }
    flyer_text { 'Beispiel' }
    create_possible { true }
    federal_states { true }
  end
end
