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
