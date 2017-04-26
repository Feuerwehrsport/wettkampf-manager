require 'highline'
require 'rbconfig'
class API::Runner
  
  def initialize
    cli.say("\n\n")

    klass = nil
    cli.choose do |menu|
      menu.prompt = 'Bitte das angeschlossene Gerät angeben:  '
      menu.choice('Timy von Alge-Timing') { klass = API::TimyReader }
      menu.choice('Computer vom Team-MV') { klass = API::ExternalReader }
    end
    cli.say("\n")

    serial_connection = cli.ask('Angeschlossene Schnittstelle? ') { |q| q.default = (os == :posix) ? '/dev/ttyUSB0' : 'COM0' }
    cli.say("\n")

    serial_connection = cli.ask('Angezeigter Sender? ') { |q| q.default = klass::DEFAULT_SENDER }
    cli.say("\n")

    url = cli.ask('URL zu Wettkampf-Manager? ') { |q| q.default = 'http://localhost:3000' }
    cli.say("\n")

    password = cli.ask('Admin-Passwort für Wettkampf-Manager:  ') { |q| q.echo = '*' }
    cli.say("\n")

    klass.start_with_check(url: url, password: password, serial_connection: serial_connection, cli: cli)
  end

  def cli
    @cli ||= HighLine.new
  end

  def os
    @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      else
        :posix
      end
    )
  end
end