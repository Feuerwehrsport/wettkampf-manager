# frozen_string_literal: true

class Score::RunDecorator < ApplicationDecorator
  decorates_association :list_entries
  decorates_association :list

  def to_s
    "#{list.name} (Lauf #{run_number})"
  end
end
