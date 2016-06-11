class Series::TeamAssessmentRows::SachsenCup < Series::TeamAssessmentRows::LaCup
  protected

  def calc_participation_count
    year = @cups.try(:values).try(:first).try(:first).try(:cup).try(:round).try(:year)
    if year.present? && year.to_i < 2015
      4
    else
      3
    end
  end
end