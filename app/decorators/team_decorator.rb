# frozen_string_literal: true

class TeamDecorator < ApplicationDecorator
  decorates_association :band
  decorates_association :people
  decorates_association :team_relays
  decorates_association :tags
  decorates_association :federal_state

  def numbered_name
    multi_team? ? "#{name} #{number}" : name
  end

  def numbered_name_with_band
    "#{numbered_name} #{band}"
  end

  def to_s(full = false)
    full ? numbered_name_with_band : numbered_name
  end

  def shortcut_name
    multi_team? ? "#{shortcut} #{number}" : shortcut
  end

  def name_cols(_assessment_type, shortcut)
    [shortcut ? shortcut_name : to_s]
  end

  def team
    self
  end

  private

  def multi_team?
    h.cache [Competition.one.updated_at, id] do
      Team.where(band: band).where(name: name).where.not(id: id).count.positive?
    end
  end
end
