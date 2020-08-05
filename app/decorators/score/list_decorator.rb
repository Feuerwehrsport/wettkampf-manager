# frozen_string_literal: true

class Score::ListDecorator < ApplicationDecorator
  def discipline
    object.assessments.first.discipline.decorate
  end

  def to_s
    name
  end

  def waiting_entries
    Score::ListEntry.waiting.where(list: object).includes(:entity).reorder(:run, :track).decorate
  end
end
