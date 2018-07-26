class Score::DoubleEventResultRowDecorator < ApplicationDecorator
  include Certificates::StorageSupport
  decorates_association :entity
  decorates_association :sum_result_entry
  decorates_association :result_entry
  decorates_association :result

  def result_entry_from(result)
    object.result_entry_from(result).try(:decorate)
  end

  def <=>(other)
    other = other.object if other.is_a?(Draper::Decorator)
    object <=> other
  end
end
