XLSX::Score::List = Struct.new(:list) do
  include XLSX::Base
  include Exports::ScoreLists

  def perform
    workbook.add_worksheet(name: list.name.truncate(30)) do |sheet|
      show_export_data(list).each { |row| sheet.add_row(content_row(row)) }
    end
  end

  protected

  def content_row(row)
    row.map do |entry|
      if entry.is_a?(Hash)
        ActionController::Base.helpers.strip_tags(entry[:content])
      else
        entry
      end
    end
  end
end
