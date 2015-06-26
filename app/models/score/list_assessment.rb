class Score::ListAssessment < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :list
end
