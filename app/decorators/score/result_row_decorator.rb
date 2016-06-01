class Score::ResultRowDecorator < ApplicationDecorator
  decorates_association :entity
  decorates_association :best_result_entry
  decorates_association :result_entry

  def result_entry_from(list)
    object.result_entry_from(list).try(:decorate)
  end

  def <=>(other)
    object <=> other.object
  end

  def to_s
    "#{entity} #{result_entry}"
  end
end