class API::LandesanlageMVReader < API::ExternalReader
  DEFAULT_SENDER = 'Landesanlage MV'

  protected

  def line_regexp
    /\A([^\r\n]*\r\n)(.*)\z/
  end

  def evaluate_line(line)
    # "*m:ss,zhm:ss,zhm:ss,zh#\r\n"
    line = line.strip
    result = line.gsub('-', '9').match(/\A\*(\d):(\d\d),(\d\d)(\d):(\d\d),(\d\d)(\d):(\d\d),(\d\d)#\z/)
    if result
      [
        { minutes: result[1].to_i, seconds: result[2].to_i, centiseconds: result[3].to_i },
        { minutes: result[4].to_i, seconds: result[5].to_i, centiseconds: result[6].to_i },
        { minutes: result[7].to_i, seconds: result[8].to_i, centiseconds: result[9].to_i },
      ].each_with_index do |time_hash, track|
        time = time_hash[:centiseconds] + time_hash[:seconds]*100 + time_hash[:minutes]*60*100
        send_data(time, "Bahn #{track + 1}")
      end
      return true
    end
    false
  end
end