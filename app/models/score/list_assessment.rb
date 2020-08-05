# frozen_string_literal: true

class Score::ListAssessment < CacheDependendRecord
  belongs_to :assessment
  belongs_to :list
end
