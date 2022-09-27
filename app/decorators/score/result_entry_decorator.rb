# frozen_string_literal: true

class Score::ResultEntryDecorator < ApplicationDecorator
  def human_time
    if result_valid?
      second_time.to_s
    elsif result_invalid?
      'D'
    elsif result_no_run?
      'N'
    else
      ''
    end
  end

  def human_time_left_target
    value = second_time_left_target.to_s
    value.presence ? "L: #{value}" : ''
  end

  def target_times_as_data(pdf: false, hint_size: 6)
    target_times = [human_time_left_target, human_time_right_target].reject(&:blank?)
    if pdf
      {
        content: "<font size='#{hint_size}'>#{target_times.join('<br/>')}</font>",
        inline_format: true, padding: [0, 0, 3, 0], valign: :center
      }
    else
      target_times.join(', ')
    end
  end

  def human_time_right_target
    value = second_time_right_target.to_s
    value.presence ? "R: #{value}" : ''
  end

  def long_human_time(seconds: 's', invalid: 'Ungültig')
    if result_valid?
      "#{second_time} #{seconds}"
    else
      invalid
    end
  end

  def to_s
    human_time
  end
end
