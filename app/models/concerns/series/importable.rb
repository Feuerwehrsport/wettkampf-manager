module Series::Importable
  extend ActiveSupport::Concern

  protected

  def convert_result_rows(result_rows)
    participations = []
    ranks = {}
    result_rows.each do |row|
      result_rows.each_with_index do |rank_row, rank|
        if (row <=> rank_row) .zero?
          ranks[row] = (rank + 1)
          break
        end
      end
    end

    result_rows.each do |row|
      rank              = ranks[row]
      time              = row.result_entry.compare_time.try(:to_i) || Firesport::INVALID_TIME
      double_rank_count = ranks.values.select { |v| v == rank }.count - 1
      points            = aggregate_class.points_for_result(rank, time, double_rank_count: double_rank_count)
      yield(row, time, points, rank)
    end
  end
end
