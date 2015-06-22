module DCup
  class SingleCompetitorResultRowDecorator < ApplicationDecorator
    decorates_association :stopwatch_time
    decorates_association :person
    
    def <=> other
      object <=> other.object
    end
  end
end