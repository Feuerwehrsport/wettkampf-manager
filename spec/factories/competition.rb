FactoryBot.define do
  factory :competition do
    name  { 'Wettkampf' }
    date  { Date.current }
    flyer_text { 'Beispiel' }
    create_possible { true }
  end
end
