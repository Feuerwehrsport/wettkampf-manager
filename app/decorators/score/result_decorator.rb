module Score
  class ResultDecorator < ApplicationDecorator
    decorates_association :assessment
    decorates_association :lists
    decorates_association :results

    def to_s
      [assessment.to_s, youth_name, name].reject(&:blank?).join(" - ")
    end

    def youth_name
      youth? ? Competition.first.youth_name : ""
    end

    def translated_group_assessment
      object.group_assessment ? 'Ja' : 'Nein'
    end
  end
end