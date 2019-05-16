XLSX::Teams = Struct.new(:teams) do
  include XLSX::Base
  include Exports::Teams

  def perform
    workbook.add_worksheet(name: Team.model_name.human(count: 0).truncate(30)) do |sheet|
      index_export_data(teams).each { |row| sheet.add_row row }
    end
  end
end
