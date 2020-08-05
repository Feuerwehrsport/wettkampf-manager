# frozen_string_literal: true

class Score::DoubleEventResult < Score::Result
  include Score::Resultable
  has_many :results, class_name: 'Score::Result', dependent: :nullify, inverse_of: :double_event_result

  def generate_rows(_group_result = false)
    rows = {}
    results.each do |result|
      result.rows.select(&:valid?).each do |result_row|
        if rows[result_row.entity.id].nil?
          rows[result_row.entity.id] = Score::DoubleEventResultRow.new(result_row.entity, self)
        end
        rows[result_row.entity.id].add_result_row(result_row)
      end
    end
    @out_of_competition_rows = []
    rows.values.select { |row| row.result_rows.count == results.count }
  end
end
