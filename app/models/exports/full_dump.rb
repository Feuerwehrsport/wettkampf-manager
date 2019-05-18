class Exports::FullDump
  def initialize
    Score::List.all.find_each do |list|
      add_file('Score::List', [list.decorate], prefix: 'startliste')
    end
    Score::Result.all.find_each do |result|
      add_file('Score::Result', [result.decorate], prefix: 'ergebnis')
    end

    if Score::CompetitionResult.all.present?
      add_file('Score::CompetitionResults', [Score::CompetitionResult.all.decorate])
    end

    people = Person.all.includes(:team)
    add_file('People', [people.female.decorate, people.male.decorate])
    add_file('Teams', [Team.all.decorate])
  end

  def to_path(path)
    FileUtils.mkdir_p(path)
    files.each do |file|
      File.open(File.join(path, file.name), 'wb') { |f| f.write(file.data) }
    end
  end

  def to_export_hash
    {
      files: files.map(&:to_export_hash),
      name: Competition.one.name,
      date: Competition.one.date.to_s,
    }
  end

  def to_export_data
    Zlib::Deflate.deflate(to_export_hash.to_json)
  end

  protected

  StoredFile = Struct.new(:name, :mimetype, :data) do
    def to_export_hash
      {
        name: name,
        mimetype: mimetype.to_s,
        compressed_data: Base64.encode64(data),
      }
    end
  end

  def add_file(klass_name, args, prefix: nil)
    %w[XLSX PDF JSON].each do |module_name|
      klass = "Exports::#{module_name}::#{klass_name}".constantize

      model = klass.perform(*args)
      name = model.filename
      name = "#{prefix}-#{name}" if prefix.present?
      files.push(StoredFile.new(name, "Mime::#{module_name}".constantize, model.bytestream))
    end
  end

  def files
    @files ||= []
  end
end
