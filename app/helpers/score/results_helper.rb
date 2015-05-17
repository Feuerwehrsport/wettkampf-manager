module Score
  module ResultsHelper
    def place_for_row row
      @rows.each_with_index do |place_row, place|
        if 0 == (row <=> place_row)
          return (place + 1) 
        end
      end
    end
  end
end
