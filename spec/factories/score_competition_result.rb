FactoryBot.define do
  factory :score_competition_result, class: 'Score::CompetitionResult' do
    name  { 'Wettkampf' }
    gender { :male }
    result_type { 'dcup' }
  end
end
