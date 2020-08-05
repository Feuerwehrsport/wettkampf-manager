# frozen_string_literal: true

class Score::ResultDecorator < ApplicationDecorator
  decorates_association :assessment
  decorates_association :lists
  decorates_association :results
  decorates_association :tags
  decorates_association :group_result

  def to_s
    [name, generated_name].reject(&:blank?).first
  end

  def generated_name
    ([assessment] + tag_names).join(' - ')
  end

  def translated_group_assessment
    object.group_assessment ? 'Ja' : 'Nein'
  end

  def rows
    @rows ||= object.rows.map(&:decorate)
  end
end
