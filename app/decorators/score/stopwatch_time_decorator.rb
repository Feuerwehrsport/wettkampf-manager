module Score
  class StopwatchTimeDecorator < ApplicationDecorator
    def to_s
      "#{second_time} s"
    end
  end
end