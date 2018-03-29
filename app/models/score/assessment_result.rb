class Score::AssessmentResult < Struct.new(:points, :assessment, :result_entry, :team, :row)
  delegate :discipline, to: :assessment
end
