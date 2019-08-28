class AssessmentDecorator < ApplicationDecorator
  decorates_association :discipline

  def to_s
    name.presence || ([discipline, translated_gender] + tag_names).reject(&:blank?).join(' - ')
  end

  def name_with_request_count
    if object.discipline.like_fire_relay? && related_requests.present?
      numbers = []
      (1..related_requests.map(&:relay_count).max).each do |number|
        count = related_requests.where('relay_count >= ?', number).count
        numbers.push("#{count}x #{(64 + number).chr}")
      end
      "#{self} (#{numbers.join(', ')})"
    else
      "#{self} (#{related_requests.count} Starter)"
    end
  end

  def translated_gender
    gender.present? ? t("gender.#{gender}") : ''
  end

  def related_requests
    if object.discipline.group_discipline?
      object.requests.where(entity_type: 'Team')
    else
      object.requests.where(entity_type: 'Person')
    end
  end
end
