require 'net/http'
require 'json'

class FireSportStatistics::API::Get
  def self.fetch(type)
    new.fetch(type)
  end

  def fetch(type)
    json_object = get(type)
    begin
      json_object.fetch(type.to_s.tr('/', '_')).map { |e| OpenStruct.new e }
    rescue KeyError => e
      raise e, OpenStruct.new(
        message: e.message,
        last_response: @last_response,
        json_object: json_object,
      )
    end
  end

  def get(type)
    handle_response(conn.get(path(type)))
  end

  protected

  def path(type)
    "/api/#{type}"
  end

  def handle_response(response)
    @last_response = response
    JSON.parse(response.body)
  end

  def conn
    @conn ||= begin
      http = Net::HTTP.new('feuerwehrsport-statistik.de', 443)
      http.use_ssl = true
      http
    end
  end
end
