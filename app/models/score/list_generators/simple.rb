module Score
  class ListGenerators::Simple < ListGenerator

    protected

    def perform_rows
      assessment_requests.to_a.shuffle
    end
  end
end