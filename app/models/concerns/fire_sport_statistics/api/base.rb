module FireSportStatistics::API::Base
  protected

  def path(type, params = {})
    "/api/#{type}?#{params&.to_query}"
  end

  def handle_response(response)
    JSON.parse(response.body)
  end

  def conn
    @conn ||= begin
      http = Net::HTTP.new('feuerwehrsport-statistik.de', 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
  end
end
