class FireSportStatistics::CompetitionDecorator < ApplicationDecorator
  def to_s
    name
  end

  def place
    name
  end
end