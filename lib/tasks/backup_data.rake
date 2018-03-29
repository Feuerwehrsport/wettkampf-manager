require 'fileutils'

desc 'backup data'
task :backup_data, %i[path verbose] => :environment do |_task, args|
  backup = LiveBackup.new(args[:path], args[:verbose].present?)
  Score::List.all.each { |list| backup.download("/score/lists/#{list.id}", "list-#{list.id}") }
  Score::Result.all.each { |list| backup.download("/score/results/#{list.id}", "result-#{list.id}") }
  backup.download('/people', 'people')
  backup.download('/teams', 'teams')
  backup.cp('db/*.sqlite3')
end

desc 'backup data every 5 minutes'
task :backup_data_recurring do
  loop do
    Rake::Task['backup_data'].reenable
    Rake::Task['backup_data'].invoke(nil, true)
    puts "Warte 5 Minuten (bis #{(Time.current + 5.minutes)})"
    sleep 5.minutes
  end
end

LiveBackup = Struct.new(:path, :verbose) do
  include Rails.application.routes.url_helpers
  def initialize(*args)
    super
    @path ||= (Competition.first.backup_path.presence || Rails.root.join('backups'))
    @backup_path = File.join(@path, Time.current.strftime('%Y%m%d-%H%M%S'))
    FileUtils.mkdir_p(@backup_path)
    print "Erzeuge #{@backup_path}"
  end

  def download(url, name, format = nil)
    if format.nil?
      download(url, name, :pdf)
      download(url, name, :xlsx)
    else
      session = ActionDispatch::Integration::Session.new(Rails.application)
      session.get(url, format: format)
      File.open(File.join(@backup_path, "#{name}.#{format}"), 'wb+') do |f|
        f.write(session.response.body)
      end
      print "Speichere #{name}.#{format}"
    end
  end

  def cp(path)
    FileUtils.cp_r(Dir.glob(Rails.root.join(path)), @backup_path, verbose: true)
  end

  def print(message)
    puts message if verbose
  end
end
