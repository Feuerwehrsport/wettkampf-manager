module Score
  class RunDecorator < ApplicationDecorator
    decorates_association :list_entries
  end
end