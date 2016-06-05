class Series::ParticipationDecorator < ApplicationDecorator
  def second_time_with_points
    "#{second_time} (#{points})"
  end
end
