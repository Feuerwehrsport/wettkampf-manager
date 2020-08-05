# frozen_string_literal: true

FactoryBot.define do
  factory :api_time_entry, class: 'API::TimeEntry' do
    time { 2233 }
    hint { 'Hinweis' }
    sender { 'Absender' }
    skip_password_authenticaton { true }
  end
end
