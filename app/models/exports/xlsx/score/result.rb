# frozen_string_literal: true

Exports::XLSX::Score::Result = Struct.new(:result) do
  include Exports::XLSX::Base
  include Exports::ScoreResults

  def perform
    single_table
    group_table if result.group_assessment? && discipline.single_discipline?
  end

  def filename
    "#{result.to_s.parameterize}.xlsx"
  end

  protected

  def bold
    @bold = workbook.styles.add_style(b: true)
  end

  def italic
    @italic = workbook.styles.add_style(i: true)
  end

  def discipline
    @discipline ||= result.assessment.discipline.decorate
  end

  def single_table
    workbook.add_worksheet(name: result.to_s.truncate_bytes(30)) do |sheet|
      build_data_rows(result, discipline, false).each { |row| sheet.add_row(row) }
    end
  end

  def group_table
    workbook.add_worksheet(name: 'Mannschaftswertung') do |sheet|
      build_group_data_rows(result).each { |row| sheet.add_row(row) }

      sheet.add_row []
      sheet.add_row []
      build_group_data_details_rows(result).each do |team_result|
        sheet.add_row [team_result.team.to_s, team_result.result_entry.to_s], style: bold
        team_result.rows_in.each { |row| sheet.add_row(row) }
        team_result.rows_out.each { |row| sheet.add_row(row, style: italic) }

        sheet.add_row []
        sheet.add_row []
      end
    end
  end
end
