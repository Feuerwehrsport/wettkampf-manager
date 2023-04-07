# frozen_string_literal: true

class TeamRelayDecorator < ApplicationDecorator
  decorates_association :team

  def to_s(full = false)
    full ? numbered_name_with_band : "#{team} #{name}"
  end

  def numbered_name_with_band
    "#{team.numbered_name_with_band} #{name}"
  end

  def shortcut_name
    "#{team.shortcut_name} #{name}"
  end

  def name_cols(_assessment_type, shortcut)
    [shortcut ? shortcut_name : to_s]
  end
end
