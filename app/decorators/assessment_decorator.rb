class AssessmentDecorator < ApplicationDecorator
  decorates_association :discipline

  def to_s
    name.present? ? name : ([discipline, translated_gender] + tag_names).reject(&:blank?).join(" - ")
  end

  def name_with_request_count
    if object.discipline.is_a?(Disciplines::FireRelay) && assessment.requests.present?
      numbers = []
      (1..assessment.requests.map(&:relay_count).max).each do |number|
        count = assessment.requests.where('relay_count >= ?', number).count
        numbers.push("#{count}x #{(64+number).chr}")
      end
      "#{to_s} (#{numbers.join(', ')})"
    else
      "#{to_s} (#{requests.count} Starter)"
    end
  end

  def translated_gender
    gender.present? ? t("gender.#{gender}") : ""
  end
end
