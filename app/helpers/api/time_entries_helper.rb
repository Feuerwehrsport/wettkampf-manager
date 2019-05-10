module API::TimeEntriesHelper
  def single_discipline?
    @list_entry.list.single_discipline?
  end

  def multiple_assessments?
    @list_entry.list.multiple_assessments?
  end

  def list_entry_options(_track, _entry)
    {}
  end
end
