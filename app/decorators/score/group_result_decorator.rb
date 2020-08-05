# frozen_string_literal: true

class Score::GroupResultDecorator < ApplicationDecorator
  decorates_association :assessment

  def rows
    @rows ||= object.rows.map(&:decorate)
  end

  def to_s
    result.decorate.to_s
  end
end
