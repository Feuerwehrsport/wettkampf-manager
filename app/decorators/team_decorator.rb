# frozen_string_literal: true

class TeamDecorator < ApplicationDecorator
  decorates_association :people
  decorates_association :team_relays
  decorates_association :tags
  decorates_association :federal_state

  def numbered_name
    multi_team? ? "#{name} #{number}" : name
  end

  def numbered_name_with_gender
    "#{numbered_name} #{translated_gender}"
  end

  def to_s(full = false)
    full ? numbered_name_with_gender : numbered_name
  end

  def numbered_shortcut_name
    multi_team? ? "#{shortcut} #{number}" : shortcut
  end

  def numbered_shortcut_name_with_gender
    "#{numbered_shortcut_name} #{gender_symbol}"
  end

  def shortcut_name(full = false)
    full ? numbered_shortcut_name_with_gender : numbered_shortcut_name
  end

  def self.human_name_cols
    ['Mannschaft']
  end

  def name_cols(_assessment_type, shortcut)
    [shortcut ? shortcut_name : to_s]
  end

  def team
    self
  end

  private

  def multi_team?
    Team.gender(gender).where(name: name).where.not(id: id).count.positive?
  end
end
