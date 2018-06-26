class Imports::Configuration < CacheDependendRecord
  serialize :data, JSON
  mount_uploader :file, Imports::ConfigurationUploader

  before_create do
    self.data = JSON.parse(file.file.read)
    data[:person_tag_list].each { |tag| tags.build(name: tag, use: true, target: :person) }
    data[:team_tag_list].each { |tag| tags.build(name: tag, use: true, target: :team) }
    data[:assessments].each do |a|
      assessments.build(name: a[:name], gender: a[:gender], discipline: a[:discipline], foreign_key: a[:id])
    end
  end

  has_many :tags, class_name: 'Imports::Tag', inverse_of: :configuration, dependent: :destroy
  has_many :assessments, class_name: 'Imports::Assessment', inverse_of: :configuration, dependent: :destroy
  accepts_nested_attributes_for :tags
  accepts_nested_attributes_for :assessments

  validates :file, presence: true

  def self.possible?
    first.blank?
  end

  def data
    JSON.parse(super.to_json, symbolize_names: true)
  end

  def name
    data[:name]
  end

  def place
    data[:place]
  end

  def error_infos
    @error_infos ||= begin
      import(true)
      ''
    rescue ActiveRecord::RecordInvalid => error
      "#{error.record.decorate}: #{error.message}"
    end
  end

  def date
    Date.parse(data[:date])
  rescue StandardError
    nil
  end

  def teams
    @teams ||= data[:teams].map { |t| Imports::Team.new(self, t) }
  end

  def people
    @people ||= data[:people].map { |t| Imports::Person.new(self, t) }
  end

  def execute=(_value)
    self.executed_at = Time.current
    import
  end

  def import(rollback = false)
    Competition.transaction do
      Competition.first.update!(name: name, place: place, date: date)
      tags.each(&:import)
      teams.each(&:import)
      people.each(&:import)
      raise ActiveRecord::Rollback if rollback
    end
  end
end
