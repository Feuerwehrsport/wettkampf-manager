require "fileutils"

desc "backup data"
task :backup_data, [] => :environment do |task, args|
  backup = LiveBackup.new
  Score::List.all.each { |list| backup.download("/score/lists/#{list.id}", "list-#{list.id}") }
  Score::Result.all.each { |list| backup.download("/score/results/#{list.id}", "result-#{list.id}") }
  backup.download("/people", "people")
  backup.download("/teams", "teams")
end


class LiveBackup
  include Rails.application.routes.url_helpers
  def initialize
    @backup_path = File.join(Rails.root, "backups", DateTime.now.to_s)
    FileUtils.mkdir_p(@backup_path)
  end

  def download url, name, format=nil
    if format.nil?
      download(url, name, :pdf)
      download(url, name, :xlsx)
    else
      session = ActionDispatch::Integration::Session.new(Rails.application)
      session.get(url, format: format)
      File.open(File.join(@backup_path, "#{name}.#{format}"), "wb+") do |f|
        f.write(session.response.body)
      end
    end
  end
end