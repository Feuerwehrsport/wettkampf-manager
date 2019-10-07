Exports::XLSX::People = Struct.new(:people) do
  include Exports::XLSX::Base
  include Exports::People

  def perform
    Genderable::GENDERS.keys.each do |gender|
      people_table(I18n.t("gender.#{gender}"), people.gender(gender).decorate) if people.gender(gender).exists?
    end
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
