class Score::CompetitionResultRowDecorator < ApplicationDecorator
  include Certificates::StorageSupport
  decorates_association :team
  decorates_association :entity
  decorates_association :assessment_results

  def <=>(other)
    other = other.object if other.is_a?(Draper::Decorator)
    object <=> other
  end
end
