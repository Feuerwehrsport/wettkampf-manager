require 'net/http'
require 'json'

class FireSportStatistics::API::Get
  include FireSportStatistics::API::Base

  def self.fetch(type)
    new.fetch(type)
  end

  def fetch(type)
    json_object = get(type)
    json_object.fetch(type.to_s.tr('/', '_')).map { |e| OpenStruct.new e }
  end

  def get(type)
    handle_response(conn.get(path(type)))
  end
end
