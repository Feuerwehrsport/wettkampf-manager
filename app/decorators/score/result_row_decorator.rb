module Score
  class ResultRowDecorator < ApplicationDecorator
    decorates_association :entity
    decorates_association :best_stopwatch_time

    def time_from list
      object.time_from(list).try(:decorate)
    end

    def <=> other
      object <=> other.object
    end

    def to_s
      "#{entity} #{best_stopwatch_time}"
    end
  end
end