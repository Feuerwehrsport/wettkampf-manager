# frozen_string_literal: true

Exports::JSON::People = Struct.new(:people) do
  include Exports::JSON::Base
  include Exports::People

  def to_hash
    {
      female: index_export_data(people.gender(:female).decorate),
      male: index_export_data(people.gender(:male).decorate),
      youth: index_export_data(people.gender(:youth).decorate),
    }
  end

  def filename
    'wettkaempfer.json'
  end
end
