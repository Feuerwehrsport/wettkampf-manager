Exports::JSON::People = Struct.new(:female, :male) do
  include Exports::JSON::Base
  include Exports::People

  def to_hash
    {
      female: index_export_data(female),
      male: index_export_data(male),
    }
  end

  def filename
    'wettkaempfer.json'
  end
end
