module DCup
  class SingleCompetitorResultDecorator < ApplicationDecorator
    decorates_association :rows
    decorates_association :assessment
    decorates_association :competitions

    def to_s
      [assessment.to_s].reject(&:blank?).join(" - ")
    end
  end
end