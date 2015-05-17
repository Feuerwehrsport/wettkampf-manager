class AssessmentDecorator < ApplicationDecorator
  decorates_association :discipline

  def to_s
    name.present? ? name : [discipline, translated_gender].reject(&:blank?).join(" - ")
  end

  def translated_gender
    gender.present? ? t("gender.#{gender}") : ""
  end
end
