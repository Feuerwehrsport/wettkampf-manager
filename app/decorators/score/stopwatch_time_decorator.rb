module Score
  class StopwatchTimeDecorator < ApplicationDecorator
    def to_s
      if list_entry.result_type == "valid"
        if time >= StopwatchTime::INVALID_TIME
          "D"
        else
          "#{second_time} s"
        end
      elsif list_entry.result_type == "invalid"
        "D"
      elsif list_entry.result_type == "no-run"
        "N"
      else
        ""
      end
    end
  end
end