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
