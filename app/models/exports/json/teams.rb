# frozen_string_literal: true

Exports::JSON::Teams = Struct.new(:teams) do
  include Exports::JSON::Base
  include Exports::Teams

  def to_hash
    {
      teams: index_export_data(teams),
    }
  end

  def filename
    'mannschaften.json'
  end
end
