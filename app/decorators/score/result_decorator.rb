module Score
  class ResultDecorator < ApplicationDecorator
    decorates_association :assessment
    decorates_association :lists
    decorates_association :results

    def to_s
      [assessment.to_s, name].reject(&:blank?).join(" - ")
    end

    def translated_group_assessment
      object.group_assessment ? 'Ja' : 'Nein'
    end
  end
end