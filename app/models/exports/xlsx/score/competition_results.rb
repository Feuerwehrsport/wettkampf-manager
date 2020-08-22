# frozen_string_literal: true

Exports::XLSX::Score::CompetitionResults = Struct.new(:results) do
  include Exports::XLSX::Base
  include Exports::CompetitionResults

  def perform
    results.each do |result|
      workbook.add_worksheet(name: result.short_name.truncate_bytes(30)) do |sheet|
        table_data(result).each { |row| sheet.add_row(row) }
      end
    end
  end

  def filename
    'gesamtwertungen.xlsx'
  end
end
