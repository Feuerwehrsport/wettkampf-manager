class Firesport::Series::Team::BaseDecorator < ApplicationDecorator
  decorates_association :team

  def participations_for_cup(cup)
    object.participations_for_cup(cup).map(&:decorate)
  end

  def second_best_time
    calculate_second_time(best_time)
  end

  def best_result_entry
    @best_result_entry ||= Score::ResultEntry.new(time_with_valid_calculation: best_time).decorate
  end

  def name_with_number
    "#{object.team.try(:name)} #{object.team_number}"
  end
end
