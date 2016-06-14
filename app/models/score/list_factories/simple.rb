class Score::ListFactories::Simple < Score::ListFactory
  protected

  def perform_rows
    assessment_requests.shuffle
  end
end