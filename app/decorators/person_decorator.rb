# frozen_string_literal: true

class PersonDecorator < ApplicationDecorator
  decorates_association :team
  decorates_association :fire_sport_statistics_person
  decorates_association :tags

  def short_first_name
    first_name.truncate(15)
  end

  def short_last_name
    last_name.truncate(15)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def team_name(assessment_type = nil)
    team_assessment_type_name [team.to_s], assessment_type
  end

  def team_assessment_type_name(name, assessment_type)
    name.push('E') if assessment_type == 'single_competitor'
    name.push('A') if assessment_type == 'out_of_competition'
    name.join(' ')
  end

  def team_shortcut_name(assessment_type = nil)
    team_assessment_type_name [team.try(:shortcut_name)], assessment_type
  end

  def translated_gender
    t("gender.#{gender}")
  end

  def to_s
    full_name
  end

  def name_cols(assessment_type, shortcut)
    team = shortcut ? team_shortcut_name(assessment_type) : team_name(assessment_type)
    [first_name, last_name, team]
  end

  def export_last_name(list, pdf: false)
    last_name = short_last_name.to_s
    tags = tag_names & list.tag_names

    if pdf
      last_name += "<font size='6'> #{tags.join(',')}</font>" if tags.present?
      { content: last_name, inline_format: true }
    else
      last_name += " (#{tags.join(', ')})" if tags.present?
      last_name
    end
  end
end
