# frozen_string_literal: true

FactoryBot.define do
  factory :person_tag, class: 'PersonTag' do
    competition { Competition.first }
    name { 'U20' }
  end
end
