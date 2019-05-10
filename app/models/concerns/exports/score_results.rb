module Exports::ScoreResults
  def build_data_rows(result, discipline, shortcut)
    header = ['Platz']
    if discipline.single_discipline_or_double_event?
      PersonDecorator.human_name_cols.each { |col| header.push col }
    else
      TeamDecorator.human_name_cols.each { |col| header.push col }
    end
    if result.is_a? Score::DoubleEventResult
      result.results.each do |_result|
        header.push(discipline.decorate.to_short)
      end
      header.push('Summe')
    else
      result.lists.each do |list|
        header.push(list.object.shortcut)
      end
      header.push('Bestzeit') unless result.lists.count == 1
    end

    data = [header]
    result.rows.each do |row|
      line = []
      line.push "#{place_for_row(result.rows, row)}."
      if discipline.single_discipline_or_double_event?
        row.entity.name_cols(row.try(:assessment_type), shortcut).each { |col| line.push col }
      else
        row.entity.name_cols(row.try(:assessment_type), false).each { |col| line.push col }
      end
      if row.is_a? Score::DoubleEventResultRow
        result.results.each { |result| line.push(row.result_entry_from(result)) }
        line.push row.sum_result_entry
      else
        result.lists.each { |list| line.push(row.result_entry_from(list)) }
        line.push row.best_result_entry unless result.lists.count == 1
      end
      data.push(line)
    end

    data.map! { |row| row.map!(&:to_s) }
  end

  def build_group_data_rows(result)
    data = [%w[Platz Name Summe]]
    result.group_result.rows.each do |row|
      data.push ["#{place_for_row(result.group_result.rows, row)}.", row.team.to_s, row.result_entry.to_s]
    end
    data
  end

  GroupDetails = Struct.new(:team, :result_entry, :rows_in, :rows_out)

  def build_group_data_details_rows(result)
    result.group_result.rows.map do |row|
      rows_in = row.rows_in.map { |result| [result.entity.to_s, result.best_result_entry.to_s] }
      rows_out = row.rows_out.map { |result| [result.entity.to_s, result.best_result_entry.to_s] }
      GroupDetails.new(row.team, row.result_entry, rows_in, rows_out)
    end
  end

  def place_for_row(rows, row)
    rows.each_with_index do |place_row, place|
      return (place + 1) if (row <=> place_row).zero?
    end
  end
end
