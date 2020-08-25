# frozen_string_literal: true

FactoryBot.define do
  factory :certificates_template, class: 'Certificates::Template' do
    name  { 'Hindernisbahn' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/disciplines/climbing_hook_ladder.png')) }
    font { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/fonts/Arial.ttf')) }

    trait :with_text_fields do
      after(:build) do |template|
        template.text_fields.push(
          Certificates::TextField.new(left: 10, top: 10, width: 100, height: 20, size: 10,
                                      key: :team_name, align: :center),
          Certificates::TextField.new(left: 30, top: 30, width: 100, height: 20, size: 10,
                                      key: :text, align: :center, text: 'Hier kommt dein Text'),
        )
      end
    end
  end
end
