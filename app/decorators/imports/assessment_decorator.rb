class Imports::AssessmentDecorator < ApplicationDecorator
  decorates_association :discipline_model

  def to_s
    [name, discipline_model, translated_gender].reject(&:blank?).join(" - ")
  end

  def translated_gender
    gender.present? ? t("gender.#{gender}") : ""
  end
end
