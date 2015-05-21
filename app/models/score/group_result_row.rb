module Score
  class GroupResultRow < Struct.new(:team, :score_count, :run_count)
    include Draper::Decoratable

    def add_result_row result_row
      @result_rows ||= []
      @result_rows.push(result_row)
    end

    def time
      calculate unless @calculated
      @time
    end

    def rows_in
      calculate unless @calculated
      @rows_in
    end

    def rows_out
      calculate unless @calculated
      @rows_out
    end

    def <=> other
      (time || -1) <=> (other.time || -1)
    end

    protected

    def calculate
      @time = 0
      @rows_in = []
      @rows_out = []

      @result_rows ||= []
      queue = @result_rows.sort
      (1..score_count).each do
        current = queue.shift
        if current.nil? || current.best_stopwatch_time.nil?
          # @time = nil
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