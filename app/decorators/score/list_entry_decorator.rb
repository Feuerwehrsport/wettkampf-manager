class Score::ListEntryDecorator < Score::ResultEntryDecorator
  decorates_association :entity
end