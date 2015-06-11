module Score
  class ListGenerators::GroupOrder < ListGenerator

    protected

    def perform_rows
      assessment.requests.order(group_competitor_order: :desc).to_a
    end
  end
end