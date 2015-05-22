module Score
  module CompetitionResultsHelper
    def group_results_for gender
      @group_results ||= {}
      @group_results[gender] ||= Result.group_assessment_for(gender).decorate
    end
  end
end
