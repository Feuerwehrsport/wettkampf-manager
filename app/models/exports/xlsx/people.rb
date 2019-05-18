Exports::XLSX::People = Struct.new(:female, :male) do
  include Exports::XLSX::Base
  include Exports::People

  def perform
    people_table('Frauen', female) if female.present?
    people_table('Männer', male)   if male.present?
  end

  def filename
    'wettkaempfer.xlsx'
  end

  protected

  def people_table(title, rows)
    workbook.add_worksheet(name: title) do |sheet|
      index_export_data(rows).each { |row| sheet.add_row(row) }
    end
  end
end
