class FireSportStatistics::TeamDecorator < ApplicationDecorator
  def to_s
    name
  end
end