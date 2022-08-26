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

  def column_count
    @column_count ||= begin
      if single_discipline?
        Competition.one.show_bib_numbers? ? 7 : 6
      else
        4
      end
    end
  end
end
