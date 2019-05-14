Score::ResultRow = Struct.new(:entity, :result) do
  include Draper::Decoratable
  attr_reader :list_entries

  def add_list(list_entry)
    @list_entries ||= []
    @list_entries.push(list_entry)
  end

  def assessment_type
    @list_entries.first.assessment_type
  end

  def best_result_entry
    @best_result_entry ||= result_entries.first
  end

  def result_entry
    best_result_entry
  end

  def result_entry_from(list)
    @list_entries.select { |entry| entry.list == list }.first
  end

  def result_entries
    @result_entries ||= @list_entries.reject(&:result_waiting?).sort
  end

  def valid?
    @valid ||= result_entries.select(&:result_valid?).present?
  end

  def competition_result_valid?
    true
  end

  def <=>(other)
    both = [result_entries, other.result_entries].map(&:count)
    (0..(both.min - 1)).each do |i|
      compare = result_entries[i] <=> other.result_entries[i]
      next if compare .zero?

      return compare
    end
    both.last <=> both.first
  end
end
