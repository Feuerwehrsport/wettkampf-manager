# frozen_string_literal: true

require 'rubyserial'
require 'highline'

def time_format(time)
  format('%<min>01d:%<sec>02d,%<mil>03d',
         min: time.to_i / 60,
         sec: time.to_i % 60,
         mil: ((time - time.to_i).round(3) * 1000).to_i)
end

task :fake_stopwatch do
  last_start = Time.current
  cli = HighLine.new
  adapter = Dir['/dev/ttyUSB*'].first
  sa = Serial.new(adapter)

  def write(serial_adapter, string)
    string += "\r"
    puts "Send: #{string.inspect}"
    serial_adapter.write(string)
  end

  loop do
    cli.say("\n\n")
    cli.say(adapter)
    cli.say("\n\n")
    cli.choose do |menu|
      menu.prompt = 'Auswahl: '
      menu.choice('1') do |_a|
        time = (Time.current - last_start)
        write(sa, "1-#{time_format(time)}")
      end
      menu.choice('2') do |_a|
        time = (Time.current - last_start)
        write(sa, "2-#{time_format(time)}")
      end
      menu.choice('s') do |_a|
        last_start = Time.current
        write(sa, 's')
      end
      menu.choice('w') do |_a|
        write(sa, 'w')
      end
      menu.choice('a') do |_a|
        time = (Time.current - last_start)
        write(sa, "##{time_format(time)}|#{time_format(time + 1.123.seconds)}*\r")
      end
      menu.choice('q') do |_a|
        exit(0)
      end
    end
  end
end

task :fake_stopwatch_platz do
  last_start = Time.current
  cli = HighLine.new
  adapter = Dir['/dev/ttyUSB*'].first
  sa = Serial.new(adapter)

  times = [0, 0, 0, 0]
  status = :waiting

  def output_time(part, status, last_start)
    if status == :waiting
      [0, 0, 0]
    else
      part = Time.current - last_start if part == 0
      time = (part.round(3) * 1000).to_i

      [
        time % 256,
        (time / 256) % 256,
        (time / 256 / 256) % 256,
      ]
    end
  end

  Thread.new do
    loop do
      bytes = [0x00, 0x52, 0x57, 0x3a, 0x01, 0x04, 0x01, 0x01] +
              output_time(times[0], status, last_start) + [0x00] +
              output_time(times[1], status, last_start) + [0x00] +
              output_time(times[2], status, last_start) + [0x00] +
              output_time(times[3], status, last_start) + [0x00] +
              [0x00, 0x00, 0x00, 0x00] +
              [0x00, 0x00, 0x00, 0x00] +
              [0x00, 0x00, 0x00, 0x00] +
              [0x00, 0x00, 0x00, 0x00] +
              [0x0d]
      p bytes

      sa.write(bytes.pack('c*'))

      sleep 0.1
    end
  end

  loop do
    cli.say("\n\n")
    cli.say(adapter)
    cli.say("\n\n")
    cli.choose do |menu|
      menu.prompt = 'Auswahl: '
      menu.choice('1') do |_a|
        times[0] = (Time.current - last_start)
      end
      menu.choice('2') do |_a|
        times[1] = (Time.current - last_start)
      end
      menu.choice('3') do |_a|
        times[2] = (Time.current - last_start)
      end
      menu.choice('4') do |_a|
        times[3] = (Time.current - last_start)
      end
      menu.choice('s') do |_a|
        times = [0, 0, 0, 0]
        last_start = Time.current
        status = :running
      end
      menu.choice('w') do |_a|
        status = :waiting
      end
      menu.choice('q') do |_a|
        exit(0)
      end
    end
  end
end
