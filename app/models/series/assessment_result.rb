# frozen_string_literal: true

class Series::AssessmentResult < ApplicationRecord
  belongs_to :assessment, class_name: 'Series::Assessment', inverse_of: :assessment_results
  belongs_to :score_result, class_name: 'Score::Result', inverse_of: :series_assessment_results
end
