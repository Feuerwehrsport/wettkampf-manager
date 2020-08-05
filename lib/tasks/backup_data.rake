# frozen_string_literal: true

require 'fileutils'

desc 'backup data'
task :backup_data, %i[path verbose] => :environment do |_task, args|
  path = args[:path]
  path ||= Competition.first.backup_path.presence
  path ||= Rails.root.join('backups')
  path = File.join(path, Time.current.strftime('%Y%m%d-%H%M%S'))

  Exports::FullDump.new.to_path(path, args[:verbose].present?)
end

desc 'backup data every 5 minutes'
task backup_data_recurring: :environment do
  loop do
    Rake::Task['backup_data'].reenable
    Rake::Task['backup_data'].invoke(nil, true)
    puts "Warte 5 Minuten (bis #{(Time.current + 5.minutes)})"
    sleep 5.minutes
  end
end
