# frozen_string_literal: true

module Score::Resultable
  def place_for_row(row)
    rows.each_with_index do |place_row, place|
      return (place + 1) if (row <=> place_row).zero?
    end
  end
end
