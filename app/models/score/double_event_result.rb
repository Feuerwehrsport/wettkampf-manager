module Score
  class DoubleEventResult < Result
    has_many :results

    def generate_rows
      rows = {}
      results.each do |result|
        result.rows.select { |row| row.best_stopwatch_time.present? && row.best_stopwatch_time.time.present?}.each do |result_row|
          if rows[result_row.entity.id].nil?
            rows[result_row.entity.id] = DoubleEventResultRow.new(result_row.entity)
          end
          rows[result_row.entity.id].add_result_row(result_row)
        end
      end
      @out_of_competition_rows = []
      rows.values.select { |row| row.result_rows.count == results.count }
    end
  end
end
