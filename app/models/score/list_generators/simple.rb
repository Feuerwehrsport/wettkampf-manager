module Score
  class ListGenerators::Simple < ListGenerator

    protected

    def perform_rows
      assessment.requests.to_a.shuffle
    end
  end
end