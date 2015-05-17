module Score
  class ResultDecorator < ApplicationDecorator
    decorates_association :assessment
    decorates_association :lists

    def to_s
      [assessment.to_s, name].reject(&:blank?).join(" - ")
    end
  end
end