# frozen_string_literal: true

class FireSportStatistics::TeamDecorator < ApplicationDecorator
  def to_s
    name
  end
end
