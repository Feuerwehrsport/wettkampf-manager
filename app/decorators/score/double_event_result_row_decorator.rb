class Score::DoubleEventResultRowDecorator < ApplicationDecorator
  decorates_association :entity
  decorates_association :sum_result_entry

  def result_entry_from(result)
    object.result_entry_from(result).try(:decorate)
  end

  def <=>(other)
    object <=> other.object
  end
end