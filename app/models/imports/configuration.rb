module Imports
  class Configuration < ActiveRecord::Base
    serialize :data, JSON
    mount_uploader :file, ConfigurationUploader

    before_create do
      self.data = JSON.parse(file.file.read)
      data[:person_tag_list].each { |tag| self.tags.build(name: tag, use: true, target: :person) }
      data[:team_tag_list].each { |tag| self.tags.build(name: tag, use: true, target: :team) }
      data[:assessments].each {|a| self.assessments.build(name: a[:name], gender: a[:gender], discipline: a[:discipline], foreign_key: a[:id]) }
    end

    has_many :tags, class_name: "Imports::Tag"
    has_many :assessments, class_name: "Imports::Assessment"
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

    def date
      Date.parse(data[:date]) rescue nil
    end

    def teams
      @teams ||= data[:teams].map { |t| Imports::Team.new(self, t) }
    end

    def people
      @people ||= data[:people].map { |t| Imports::Person.new(self, t) }
    end

    def execute=(value)
      self.executed_at = Time.now
      import
    end

    def import
      Competition.transaction do
        Competition.first.update_attributes!(name: name, place: place, date: date)
        tags.each(&:import)
        teams.each(&:import)
        people.each(&:import)
      end
    end
  end
end