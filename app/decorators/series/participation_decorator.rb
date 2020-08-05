# frozen_string_literal: true

class Series::ParticipationDecorator < ApplicationDecorator
  decorates_association :result_entry
  def result_entry_with_points
    "#{result_entry} (#{points})"
  end
end
