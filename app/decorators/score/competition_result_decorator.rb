# frozen_string_literal: true

class Score::CompetitionResultDecorator < ApplicationDecorator
  decorates_association :rows
  decorates_association :results
  decorates_association :band

  def to_s
    [object.name, band.name].reject(&:blank?).join(' - ')
  end

  def short_name
    [object.name, band.name].reject(&:blank?).map { |s| s.truncate(20) }.join(' - ').truncate(30)
  end
end
