module Score
  class DoubleEventResultRowDecorator < ApplicationDecorator
    decorates_association :entity
    decorates_association :sum_stopwatch_time

    def time_from result
      object.time_from(result).try(:decorate)
    end

    def <=> other
      object <=> other.object
    end
  end
end