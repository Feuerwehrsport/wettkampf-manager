module Score
  class StopwatchTimeDecorator < ApplicationDecorator
    def to_s
      if list_entry.result_type == "valid"
        "#{second_time} s"
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