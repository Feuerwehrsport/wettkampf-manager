require 'highline'
require 'rbconfig'
class API::Runner
  def initialize
    cli.say("\n\n")

    klass = nil

    default = config[:klass_select].present? ? " |#{config[:klass_select]}|" : ''
    cli.choose do |menu|
      menu.prompt = "Bitte das angeschlossene Gerät angeben#{default}: "
      menu.choice('Timy von Alge-Timing') do |a|
        config[:klass_select] = a
        klass = API::TimyReader
      end
      menu.choice('Computer vom Team-MV') do |a|
        config[:klass_select] = a
        klass = API::TeamComputerReader
      end
      menu.choice('Landesanlage MV') do |a|
        config[:klass_select] = a
        klass = API::LandesanlageMVReader
      end
      menu.default = config[:klass_select]
    end
    cli.say("\n")

    default = config[:serial_connection] || (os == :posix ? '/dev/ttyUSB0' : 'COM0')
    serial_connection = cli.ask('Angeschlossene Schnittstelle? ') { |q| q.default = default }
    config[:serial_connection] = serial_connection
    cli.say("\n")

    sender = ''
    default = config[:sender_select].present? ? " |#{config[:sender_select]}|" : ''
    cli.choose do |menu|
      menu.prompt = "Zeiten der Disziplin#{default}:  "
      Discipline.types_with_key.each do |key, k|
        next if key == :zk
        menu.choice(k.model_name.human) do |a|
          config[:sender_select] = a
          sender = k.model_name.human
        end
      end
      menu.choice('Anderes') do |a|
        config[:sender_select] = a
        sender = cli.ask('Name der Disziplin? ') { |q| q.default = klass::DEFAULT_SENDER }
      end
      menu.default = config[:sender_select]
    end
    cli.say("\n")

    default = config[:url] || (os == :posix ? 'http://localhost:3000' : 'http://localhost')
    url = cli.ask('URL zu Wettkampf-Manager? ') { |q| q.default = default }
    config[:url] = url
    cli.say("\n")

    password = cli.ask('Admin/API-Passwort für Wettkampf-Manager:  ') { |q| q.echo = '*' }
    cli.say("\n")

    write_config(config)

    klass.start_with_check(url: url, password: password, serial_connection: serial_connection, cli: cli, sender: sender)
  end

  def cli
    @cli ||= HighLine.new
  end

  def os
    @os ||= begin
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      else
        :posix
      end
    end
  end

  protected

  def config_file_path
    Rails.root.join('api_runner.config')
  end

  def write_config(hash)
    File.write(config_file_path, hash.to_json)
  end

  def config
    @config ||= begin
      if File.file?(config_file_path)
        begin
          JSON.parse(File.read(config_file_path), symbolize_names: true)
        rescue JSON::ParserError
          {}
        end
      else
        {}
      end
    end
  end
end
