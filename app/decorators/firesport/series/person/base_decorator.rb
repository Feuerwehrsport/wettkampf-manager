class Firesport::Series::Person::BaseDecorator < ApplicationDecorator
  decorates_association :round
  decorates_association :entity

  def participation_for_cup(cup)
    object.participation_for_cup(cup).try(:decorate)
  end

  def second_best_time
    calculate_second_time(best_time)
  end

  def best_result_entry
    @best_result_entry ||= Score::ResultEntry.new(time_with_valid_calculation: best_time).decorate
  end

  def second_sum_time
    calculate_second_time(sum_time)
  end

  def sum_result_entry
    @sum_result_entry ||= Score::ResultEntry.new(time_with_valid_calculation: sum_time).decorate
  end
end
