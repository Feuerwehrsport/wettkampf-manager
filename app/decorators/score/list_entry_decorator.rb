# frozen_string_literal: true

class Score::ListEntryDecorator < Score::ResultEntryDecorator
  decorates_association :entity
  decorates_association :list

  def overview
    "#{list}; #{entity}: #{long_human_time}"
  end
end
