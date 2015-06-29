module Score
  module ResultsHelper
    def place_for_row row
      @rows.each_with_index do |place_row, place|
        if 0 == (row <=> place_row)
          return (place + 1) 
        end
      end
    end

    def place_for_group_row row
      @group_result_rows.each_with_index do |place_row, place|
        if 0 == (row <=> place_row)
          return (place + 1) 
        end
      end
    end

    def build_group_data_rows
      data = [["Platz", "Name", "Summe"]]
      @group_result_rows.each do |row|
        data.push ["#{place_for_group_row row}.", row.team.to_s, row.time.to_s]
      end
      data
    end

    def build_group_data_details_rows
      result = Struct.new(:team, :time, :rows_in, :rows_out)
      @group_result_rows.map do |row|
        rows_in = row.rows_in.map { |result| [result.entity.to_s, result.best_stopwatch_time.to_s] }
        rows_out = row.rows_out.map { |result| [result.entity.to_s, result.best_stopwatch_time.to_s] }
        result.new(row.team, row.time, rows_in, rows_out)
      end
    end

    def build_data_rows(shortcut)
      header = ["Platz"]
      if @discipline.single_discipline? || @discipline.is_a?(Disciplines::DoubleEvent)
        PersonDecorator.human_name_cols.each { |col| header.push col }
      else
        TeamDecorator.human_name_cols.each { |col| header.push col }
      end
      if @score_result.is_a? Score::DoubleEventResult
        @score_result.results.each do |result|
          header.push(result.assessment.discipline.decorate.to_short)
        end
        header.push("Summe")
      else
        @score_result.lists.each do |list|
          header.push(list.object.shortcut)
        end
        header.push("Bestzeit")
      end

      data = [header]
      @rows.each do |row|
        line = []
        line.push "#{place_for_row row}."
        row.entity.name_cols(row.assessment_type, shortcut).each { |col| line.push col }
        if row.is_a? Score::DoubleEventResultRow
          @score_result.results.each { |result| line.push(row.time_from(result)) }
          line.push row.sum_stopwatch_time
        else
          @score_result.lists.each { |list| line.push(row.time_from(list)) }
          line.push row.best_stopwatch_time
        end
        data.push(line)
      end

      data.map! {|row| row.map!(&:to_s) }
    end

    def row_invalid_class row
      row.valid? ? "" : "danger"
    end
  end
end
