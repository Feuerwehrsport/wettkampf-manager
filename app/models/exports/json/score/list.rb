# frozen_string_literal: true

Exports::JSON::Score::List = Struct.new(:list) do
  include Exports::JSON::Base
  include Exports::ScoreLists

  def to_hash
    {
      rows: show_export_data(list).map { |row| content_row(row) },
    }
  end

  def filename
    "#{list.name.parameterize}.json"
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
