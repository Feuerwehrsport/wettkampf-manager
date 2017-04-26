module API::TimeEntriesHelper
  def single_discipline?
    @list_entry.list.assessments.first.discipline.single_discipline?
  end

  # def multiple_assessments?
  #   @score_list.assessments.count > 1
  # end

  def list_entry_options track, entry
    {}
  end
end
