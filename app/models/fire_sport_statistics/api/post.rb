require 'net/http'
require 'json'

class FireSportStatistics::API::Post
  include FireSportStatistics::API::Base

  attr_reader :cookies

  def post(type, data_hash)
    login if cookies.blank?

    handle_response(conn.post(path(type), data_hash.to_query, 'Cookie' => cookies))
  end

  def login
    response = conn.post(path(:api_users), { 'api_user[name]': Competition.one.name }.to_query)
    raise 'Login failed' unless response.code == '200'

    @cookies = response.get_fields('set-cookie').map { |cookie| cookie.split('; ')[0] }.join('; ')
  end
end
