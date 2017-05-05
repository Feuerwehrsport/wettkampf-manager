class Series::AssessmentResult < ActiveRecord::Base
  belongs_to :assessment, class_name: 'Series::Assessment'
  belongs_to :score_result, class_name: 'Score::Result'
end
