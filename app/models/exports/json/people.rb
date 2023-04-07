# frozen_string_literal: true

Exports::JSON::People = Struct.new(:people) do
  include Exports::JSON::Base
  include Exports::People

  def to_hash
    {
      bands: Band.all.map do |band|
               {
                 name: band.name,
                 gender: band.gender,
                 people: index_export_data(band, people.where(band: band).decorate),
               }
             end,
    }
  end

  def filename
    'wettkaempfer.json'
  end
end
