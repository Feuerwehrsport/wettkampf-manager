module Score
  class CompetitionResultRowDecorator < ApplicationDecorator
    decorates_association :team
    decorates_association :assessment_results
  end
end