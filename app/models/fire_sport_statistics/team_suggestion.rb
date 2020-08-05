# frozen_string_literal: true

FireSportStatistics::TeamSuggestion = Struct.new(:team) do
  include Draper::Decoratable
  delegate :first, :present?, to: :suggestions

  def suggestions
    @suggestions ||= FireSportStatistics::Team.for_team(team)
  end

  def match?
    match = suggestions.count == 1
    team.fire_sport_statistics_team_id = first.id if match
    match
  end
end
