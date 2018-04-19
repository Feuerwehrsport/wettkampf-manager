class Score::ResultRowDecorator < ApplicationDecorator
  include Certificates::StorageSupport
  decorates_association :entity
  decorates_association :best_result_entry
  decorates_association :result_entry
  decorates_association :result

  def result_entry_from(list)
    object.result_entry_from(list).try(:decorate)
  end

  def <=>(other)
    object <=> (other.is_a?(Draper::Decorator) ? other.object : other)
  end

  def to_s
    "#{entity} #{result_entry}"
  end
end
