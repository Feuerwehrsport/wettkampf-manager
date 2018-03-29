class FireSportStatistics::PersonDecorator < ApplicationDecorator
  def to_s
    full_name
  end

  def team_list
    teams.map(&:short).join(', ')
  end
end
