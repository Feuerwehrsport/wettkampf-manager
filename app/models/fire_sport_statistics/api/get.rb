# frozen_string_literal: true

require 'net/http'
require 'json'

class FireSportStatistics::API::Get
  include FireSportStatistics::API::Base

  def self.fetch(type, params = nil)
    new.fetch(type, params)
  end

  def fetch(type, params = nil)
    json_object = get(type, params)
    json_object.fetch(type.to_s.tr('/', '_')).map { |e| OpenStruct.new e }
  end

  def get(type, params = nil)
    handle_response(conn.get(path(type, params)))
  end
end
