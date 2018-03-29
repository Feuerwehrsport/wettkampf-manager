class Series::AssessmentDecorator < ApplicationDecorator
  decorates_association :cups
  decorates_association :participations
  decorates_association :round
  decorates_association :discipline_model

  def to_s
    name
  end

  def rows
    object.rows.map(&:decorate)
  end

  def score_result_label
    "#{object.class.model_name.human}: #{to_label}"
  end
end
