# frozen_string_literal: true

class API::PlatzGamstaedtReader < API::ExternalReader
  DEFAULT_SENDER = 'Platz-Gamstädt'

  def initialize(*args)
    super
    @track_times = {
      1 => [[0, 0, 0], [0, 0, 0]],
      2 => [[0, 0, 0], [0, 0, 0]],
    }
  end

  def perform
    loop do
      byte = serial_adapter.getbyte
      if byte.nil?
        sleep 0.1
      else
        evaluate_byte(byte)
        send_to_output([byte].pack('c*'))
      end
    end
  rescue RubySerial::Error => e
    log_send_error("Schnittstelle: #{e.message}")
  end

  protected

  def evaluate_byte(byte)
    @current_line ||= []
    @current_line.push(byte)
    return unless byte == 0x0D # \r

    evaluate_line(@current_line)
    @current_line = []
  end

  def evaluate_line(byte_array)
    return if byte_array[0] != 0x0  # NULL
    return if byte_array[1] != 0x52 # R
    return if byte_array[2] != 0x57 # W
    return if byte_array[3] != 0x3A # :
    return if byte_array.length != 41

    # puts byte_array[4..-2].map { |n| format('%02X', (n & 0xFF)) }.join(' ')
    # byte_array[4] immer 0x01
    # byte_array[5] 0x02 => Einbahnbetrieb; 0x04 => Zweibahnbetrieb

    # byte_array[6] immer 0x01
    # byte_array[7] immer 0x00 oder 0x01

    tracks = [track_time(
      1,
      calculate_time(byte_array[8],  byte_array[9],  byte_array[10]),
      calculate_time(byte_array[12], byte_array[13], byte_array[14]),
    )]

    if byte_array[5] == 0x04
      tracks.push(
        track_time(
          2,
          calculate_time(byte_array[16], byte_array[17], byte_array[18]),
          calculate_time(byte_array[20], byte_array[21], byte_array[22]),
        ),
      )
    end
    return if tracks.any?(&:nil?)
    return if tracks == @last_tracks

    @last_tracks = tracks.dup

    tracks.each_with_index do |centiseconds, track|
      send_data(centiseconds, "Bahn #{track + 1}")
    end
  end

  def calculate_time(time_a, time_b, time_c)
    (time_a + time_b * 256 + time_c * 256 * 256) / 10
  end

  def track_time(track, time0, time1)
    return unless [time_stopped?(track, 0, time0), time_stopped?(track, 1, time1)].all?

    [time0, time1].max
  end

  def time_stopped?(track, part, time)
    @track_times[track][part].push(time)
    @track_times[track][part].shift
    uniq_values = @track_times[track][part].uniq
    uniq_values.length == 1 && uniq_values != [0]
  end
end
