# frozen_string_literal: true

Score::AssessmentResult = Struct.new(:points, :assessment, :result_entry, :team, :row) do
  delegate :discipline, to: :assessment
end
