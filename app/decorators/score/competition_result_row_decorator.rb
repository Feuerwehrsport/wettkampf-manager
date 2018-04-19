class Score::CompetitionResultRowDecorator < ApplicationDecorator
  include Certificates::StorageSupport
  decorates_association :team
  decorates_association :entity
  decorates_association :assessment_results

  def <=>(other)
    object <=> other.object
  end
end
