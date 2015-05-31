module Score
  class AssessmentResult < Struct.new(:points, :assessment, :time, :team, :row)
    delegate :discipline, to: :assessment
  end
end