class API::TeamComputerReader < API::ExternalReader
  DEFAULT_SENDER = 'Team Computer'.freeze

  protected

  def line_regexp
    /\A([^\r\n]*\r\n)(.*)\z/
  end

  def evaluate_line(line)
    # "#0:08,000|0:09,343*\r\n"
    line = line.strip
    line = line.gsub(/\A[^#]*#/, '#')
    line = line.gsub(/\*[^\*]*\z/, '*')
    result = line.match(/\A#(\d+):(\d+),(\d+)\|(\d+):(\d+),(\d+)\*\z/)
    if result
      [
        { minutes: result[1].to_i, seconds: result[2].to_i, milliseconds: result[3].to_i },
        { minutes: result[4].to_i, seconds: result[5].to_i, milliseconds: result[6].to_i },
      ].each_with_index do |time_hash, track|
        centiseconds = (time_hash[:milliseconds].to_f / 10).floor
        time = centiseconds + time_hash[:seconds] * 100 + time_hash[:minutes] * 60 * 100
        send_data(time, "Bahn #{track + 1}")
      end
      return true
    end
    false
  end
end
