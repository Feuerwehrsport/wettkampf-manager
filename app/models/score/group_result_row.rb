module Score
  class GroupResultRow < Struct.new(:team, :score_count, :run_count)
    include Draper::Decoratable

    def entity
      team
    end

    def add_result_row result_row
      @result_rows ||= []
      @result_rows.push(result_row)
    end

    def time
      calculate
      StopwatchTime.aggregated_time(@time, valid?)
    end

    def rows_in
      calculate
      @rows_in
    end

    def rows_out
      calculate
      @rows_out
    end

    def valid?
      calculate
      @valid
    end

    def <=> other
      (time || StopwatchTime::INVALID_TIME) <=> (other.time || StopwatchTime::INVALID_TIME)
    end

    protected

    def calculate
      return if @calculated
      @time = 0
      @rows_in = []
      @rows_out = []
      @result_rows ||= []
      @valid = @result_rows.count >= score_count && @result_rows.count <= run_count
      queue = @result_rows.sort
      (1..score_count).each do
        current = queue.shift
        if current.nil? || !current.valid?
          @time = nil
        else
          @time += current.best_stopwatch_time.time
        end
        @rows_in.push(current) if current.present?
      end
      (score_count + 1..run_count).each do
        current = queue.shift
        @rows_out.push(current) if current.present?
      end
      @calculated = true
    end
  end
end