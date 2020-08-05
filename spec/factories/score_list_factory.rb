FactoryBot.define do
  factory :score_list_factory, class: 'Score::ListFactory' do
    assessments { [create(:assessment)] }
    discipline { assessments.first.discipline }
    name { 'Hakenleitersteigen - Lauf 1' }
    shortcut { 'Lauf 1' }
    track_count { 2 }
    results { [create(:score_result, assessment: assessments.first)] }

    factory :score_list_factory_simple, class: 'Score::ListFactories::Simple' do
    end

    factory :score_list_factory_best, class: 'Score::ListFactories::Best' do
      before_result { create(:score_result, assessment: assessments.first) }
      best_count { 2 }
    end

    factory :score_list_factory_fire_relay, class: 'Score::ListFactories::FireRelay' do
    end

    factory :score_list_factory_group_order, class: 'Score::ListFactories::GroupOrder' do
    end

    factory :score_list_factory_track_change, class: 'Score::ListFactories::TrackChange' do
    end

    factory :score_list_factory_track_same, class: 'Score::ListFactories::TrackSame' do
    end

    factory :score_list_factory_track_genderable, class: 'Score::ListFactories::TrackGenderable' do
    end
  end
end
