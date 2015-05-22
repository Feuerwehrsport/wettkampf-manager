module Score
  class AssessmentResult < Struct.new(:points, :assessment, :time, :team)
    delegate :discipline, to: :assessment
  end
end