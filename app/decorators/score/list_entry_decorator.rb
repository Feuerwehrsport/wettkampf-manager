module Score
  class ListEntryDecorator < ApplicationDecorator
    decorates_association :entity
  end
end