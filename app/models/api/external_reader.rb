require 'uri'
require 'net/http'

class API::ExternalReader
  DEFAULT_SENDER = ''
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  attr_accessor :url, :password, :sender, :cli

  def self.start_with_check(options)
    instance = new(options)
    if instance.check
      instance.cli.say('System-Check erfolgreich')
      instance.perform
    else
      instance.cli.say('System-Check fehlgeschlagen')
    end
  end

  def check
    send_data(0, 'System-Check')
  end

  def log_raw(line)
    Rails.logger.info(line)
    p line
  end

  def send_data(time, hint)
    params = { api_time_entry: { time: time, hint: hint, password: password, sender: sender } }
    begin
      http = Net::HTTP.new(http_url.host, http_url.port)
      response = http.post(http_url.path, params.to_query)
      response =  JSON.parse(response.body)
      if !response['success']
        log_send_error(response['error'])
      else
        return true
      end
    rescue JSON::ParserError => error
      log_send_error(error.message)
      Rails.logger.error(error.inspect)
    rescue Errno::ECONNREFUSED => error
      log_send_error(error.message)
      Rails.logger.error(error.inspect)
    rescue Net::ReadTimeout => error
      log_send_error(error.message)
      Rails.logger.error(error.inspect)
    end
    false
  end

  def log_send_error(message)
    cli.say("Fehler: #{message}")
  end

  def http_url
    @http_url ||= URI.parse("#{url}/api/time_entries")
  end

  def evaluate_with_log_line(line)
    log_start = evaluate_line(line) ? 'valid:  ' : 'invalid:'
    log_raw(log_start + ' ' + line)
  end
end