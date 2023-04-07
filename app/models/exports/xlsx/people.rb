# frozen_string_literal: true

Exports::XLSX::People = Struct.new(:people) do
  include Exports::XLSX::Base
  include Exports::People

  def perform
    Band.all.find_each do |band|
      people_table(band, people.where(band: band).decorate)
    end
  end

  def filename
    'wettkaempfer.xlsx'
  end

  protected

  def people_table(band, rows)
    return if rows.blank?

    workbook.add_worksheet(name: band.name.truncate_bytes(30)) do |sheet|
      index_export_data(band, rows).each { |row| sheet.add_row(row) }
    end
  end
end
