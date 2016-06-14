FactoryGirl.define do
  factory :competition do
    name  'Wettkampf'
    date  Date.today
    flyer_text 'Beispiel'
    create_possible true
  end
end