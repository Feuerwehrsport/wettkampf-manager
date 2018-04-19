class Score::CompetitionResultRowDecorator < ApplicationDecorator
  decorates_association :team
  decorates_association :assessment_results

  def <=>(other)
    object <=> other.object
  end
end
