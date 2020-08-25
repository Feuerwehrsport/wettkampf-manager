# frozen_string_literal: true

module Exports::ScoreResults
  def build_data_rows(result, discipline, shortcut, export_headers: false)
    data = [build_data_headline(result, discipline, export_headers: export_headers)]
    result.rows.each do |row|
      line = []
      line.push "#{result.place_for_row(row)}."
      if discipline.single_discipline_or_double_event?
        row.entity.name_cols(row.try(:assessment_type), shortcut).each { |col| line.push col }
      else
        row.entity.name_cols(row.try(:assessment_type), false).each { |col| line.push col }
      end
      if row.is_a? Score::DoubleEventResultRow
        result.results.each { |inner_result| line.push(row.result_entry_from(inner_result)) }
        line.push row.sum_result_entry
      else
        result.lists.each { |list| line.push(row.result_entry_from(list)) }
        line.push row.best_result_entry unless result.lists.count == 1
      end
      data.push(line)
    end

    data.map! { |row| row.map!(&:to_s) }
  end

  def build_data_headline(result, discipline, export_headers: false)
    header = ['Platz']
    if discipline.single_discipline_or_double_event?
      header.push 'Vorname', 'Nachname', 'Mannschaft'
    else
      header.push 'Mannschaft'
    end
    if result.is_a? Score::DoubleEventResult
      result.results.each do |sub_result|
        header.push(sub_result.assessment.discipline.decorate.to_short)
      end
      header.push('Summe')
    else
      result.lists.each do |list|
        header.push(export_headers ? 'time' : list.object.shortcut)
      end
      header.push('Bestzeit') unless result.lists.count == 1
    end
    header
  end

  def build_group_data_rows(result)
    data = [%w[Platz Name Summe]]
    result.group_result.rows.each do |row|
      data.push ["#{result.group_result.place_for_row(row)}.", row.team.to_s, row.result_entry.to_s]
    end
    data
  end

  GroupDetails = Struct.new(:team, :result_entry, :rows_in, :rows_out)

  def build_group_data_details_rows(result)
    result.group_result.rows.map do |row|
      rows_in = row.rows_in.map { |r| [r.entity.to_s, r.best_result_entry.to_s] }
      rows_out = row.rows_out.map { |r| [r.entity.to_s, r.best_result_entry.to_s] }
      GroupDetails.new(row.team, row.result_entry, rows_in, rows_out)
    end
  end
end
