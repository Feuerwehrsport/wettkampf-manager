module Score
  module ResultsHelper
    def place_for_row row
      @rows.each_with_index do |place_row, place|
        if 0 == (row <=> place_row)
          return (place + 1) 
        end
      end
    end

    def build_group_data_rows
      data = [["Name", "Summe"]]
      @group_result_rows.each do |row|
        data.push [row.team.to_s, row.time.to_s]
      end
      data
    end

    def build_data_rows     
      header = ["Platz", "Name"]
      if @score_result.is_a? Score::DoubleEventResult
        header.push("Summe")
        @score_result.results.each do |result|
          header.push(result.assessment.discipline.decorate)
        end
      else
        header.push("Bestzeit")
        @score_result.lists.each do |list|
          header.push(list.object.name)
        end
      end

      data = [header]
      @rows.each do |row|
        line = []
        line.push "#{place_for_row row}."
        line.push row.entity
        if row.is_a? Score::DoubleEventResultRow
          line.push row.sum_stopwatch_time
          @score_result.results.each { |result| line.push(row.time_from(result)) }
        else
          line.push row.best_stopwatch_time
          @score_result.lists.each { |list| line.push(row.time_from(list)) }
        end
        data.push(line)
      end

      data.map! {|row| row.map!(&:to_s) }
    end
  end
end
