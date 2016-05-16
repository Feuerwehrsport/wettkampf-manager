class AssessmentDecorator < ApplicationDecorator
  decorates_association :discipline

  def to_s
    name.present? ? name : ([discipline, translated_gender] + tag_names).reject(&:blank?).join(" - ")
  end

  def translated_gender
    gender.present? ? t("gender.#{gender}") : ""
  end
end
