class Score::CompetitionResultDecorator < ApplicationDecorator
  decorates_association :rows
  decorates_association :results

  def to_s
    [object.name, translated_gender].reject(&:blank?).join(' - ')
  end

  def translated_gender
    t("gender.#{gender}")
  end
end