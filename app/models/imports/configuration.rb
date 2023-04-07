# frozen_string_literal: true

class Imports::Configuration < CacheDependendRecord
  serialize :data, JSON
  has_one_attached :file

  before_create do
    self.data = JSON.parse(file.download)
  end

  validates :file, presence: true

  def self.possible?
    !exists?
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

  def bands
    @bands ||= data[:bands].each_with_index.map { |b, position| Imports::Band.new(self, b, position + 1) }
  end

  def tags
    @tags ||= begin
      pts = []
      tts = []
      data[:bands].each do |b|
        pts += b[:person_tag_list]
        tts += b[:team_tag_list]
      end
      ts = pts.uniq.map { |t| Imports::Tag.new(self, t, 'person') }
      ts += tts.uniq.map { |t| Imports::Tag.new(self, t, 'team') }
      ts
    end
  end

  def error_infos
    @error_infos ||= begin
      import(true)
      ''
                     rescue ActiveRecord::RecordInvalid => e
                       "#{e.record.decorate}: #{e.message}"
    end
  end

  def date
    Date.parse(data[:date])
  rescue StandardError
    nil
  end

  def execute=(_value)
    self.executed_at = Time.current
    import
  end

  def import(rollback = false)
    Competition.transaction do
      Competition.first.update!(name: name, place: place, date: date)
      tags.each(&:import)
      bands.each(&:import)
      raise ActiveRecord::Rollback if rollback
    end
  end
end
