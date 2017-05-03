class API::TimyReader < API::ExternalReader
  DEFAULT_SENDER = 'Timy'

  protected

  def line_regexp
    /\A([^\r]*\r)(.*)\z/
  end

  def evaluate_line(line)
    # "c0008 C0  19:19:35.2365 00\r"
    if line.size.in?([27, 31])
      info = line[0]
      bib_number = line[1..4]
      channel = line[6..8]
      time_string = line[10..23]
      group = line[24..25]

      if channel.downcase.strip.first(2).in?(['c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8'])
        track = channel.downcase.strip.first(2).last
        result = time_string.match(/\A(\d\d):(\d\d):(\d\d).(\d\d)/)
        if result
          hours = result[1].to_i
          minutes = result[2].to_i
          seconds = result[3].to_i
          centiseconds = result[4].to_i
          time = centiseconds + seconds*100 + minutes*60*100 + hours*100*60*60
          send_data(time, "Bahn #{track}")
          return true
        end
      end
    end
    false
  end
end