module Score::ResultsHelper
  include Exports::ScoreResults

  def row_invalid_class(row)
    row.valid? ? '' : 'danger'
  end
end
