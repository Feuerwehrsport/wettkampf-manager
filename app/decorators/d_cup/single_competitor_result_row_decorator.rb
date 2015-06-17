module DCup
  class SingleCompetitorResultRowDecorator < ApplicationDecorator
    decorates_association :stopwatch_time
    
    def <=> other
      object <=> other.object
    end
  end
end