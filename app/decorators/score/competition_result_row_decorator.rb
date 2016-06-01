class Score::CompetitionResultRowDecorator < ApplicationDecorator
  decorates_association :team
  decorates_association :assessment_results
end