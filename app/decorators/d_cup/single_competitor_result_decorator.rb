module DCup
  class SingleCompetitorResultDecorator < ApplicationDecorator
    decorates_association :rows
    decorates_association :assessment

    def to_s
      [assessment.to_s, youth_name].reject(&:blank?).join(" - ")
    end

    def youth_name
      youth ? Competition.one.youth_name : ""
    end
  end
end