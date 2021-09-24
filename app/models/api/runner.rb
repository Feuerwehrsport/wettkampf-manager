# frozen_string_literal: true

require 'highline'
require 'rbconfig'

class API::Runner
  attr_accessor :klass, :serial_connection, :serial_connection_output, :sender, :url, :password

  def initialize
    cli.say("\n\n")
    ask_klass
    ask_serial_connection
    ask_serial_connection_output
    ask_sender
    ask_url
    ask_password

    write_config(config)

    klass.start_with_check(url: url, password: password, serial_connection: serial_connection,
                           serial_connection_output: serial_connection_output, cli: cli, sender: sender)
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

  def ask_klass
    default = config[:klass_select].present? ? " |#{config[:klass_select]}|" : ''
    cli.choose do |menu|
      menu.prompt = "Bitte das angeschlossene Gerät angeben#{default}: "
      menu.choice('Timy von Alge-Timing') do |a|
        config[:klass_select] = a
        self.klass = API::TimyReader
      end
      menu.choice('Computer vom Team-MV') do |a|
        config[:klass_select] = a
        self.klass = API::TeamComputerReader
      end
      menu.choice('Landesanlage MV') do |a|
        config[:klass_select] = a
        self.klass = API::LandesanlageMVReader
      end
      menu.choice('Anlage von Platz-Gamstädt') do |a|
        config[:klass_select] = a
        self.klass = API::PlatzGamstaedtReader
      end
      menu.default = config[:klass_select]
    end
    cli.say("\n")
  end

  def ask_serial_connection
    if os == :posix
      cli.choose do |menu|
        default = config[:serial_connection] || Dir['/dev/ttyUSB*'].first
        menu.prompt = "Angeschlossene Schnittstelle? #{default}: "
        Dir['/dev/ttyUSB*'].each do |file|
          menu.choice(file) do |a|
            config[:serial_connection] = a
            self.serial_connection = a
          end
        end
        menu.default = default
      end
    else
      default = config[:serial_connection] || 'COM0'
      self.serial_connection = cli.ask('Angeschlossene Schnittstelle? ') { |q| q.default = default }
      config[:serial_connection] = serial_connection
    end
    cli.say("\n")
  end

  def ask_serial_connection_output
    cli.choose do |menu|
      default = config[:serial_connection_output] || 'Nein'
      menu.prompt = "Schnittstellen-Eingabe an andere Schnittstelle weitergeben? Z.B. für Anzeigetafeln? #{default}: "
      menu.choice('Nein') do |a|
        config[:serial_connection_output] = a
        self.serial_connection_output = nil
      end
      Dir['/dev/ttyUSB*'].each do |file|
        menu.choice(file) do |a|
          config[:serial_connection] = a
          self.serial_connection = a
        end
      end
      menu.default = default
    end
    cli.say("\n")
  end

  def ask_sender
    self.sender = ''
    default = config[:sender_select].present? ? " |#{config[:sender_select]}|" : ''
    cli.choose do |menu|
      menu.prompt = "Zeiten der Disziplin#{default}:  "
      Discipline.types_with_key.each do |key, k|
        next if key == :zk

        menu.choice(k.model_name.human) do |a|
          config[:sender_select] = a
          self.sender = k.model_name.human
        end
      end
      menu.choice('Anderes') do |a|
        config[:sender_select] = a
        self.sender = cli.ask('Name der Disziplin? ') { |q| q.default = klass::DEFAULT_SENDER }
      end
      menu.default = config[:sender_select]
    end
    cli.say("\n")
  end

  def ask_url
    default = config[:url] || (os == :posix ? 'http://localhost:3000' : 'http://localhost')
    self.url = cli.ask('URL zu Wettkampf-Manager? ') { |q| q.default = default }
    config[:url] = url
    cli.say("\n")
  end

  def ask_password
    self.password = cli.ask('Admin/API-Passwort für Wettkampf-Manager:  ') { |q| q.echo = '*' }
    cli.say("\n")
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
