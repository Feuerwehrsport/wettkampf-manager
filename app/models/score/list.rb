module Score
  class List < ActiveRecord::Base
    belongs_to :assessment
    has_many :entries, -> { order(:run).order(:track) }, class_name: "Score::ListEntry"
    validates :name, :assessment, :track_count, presence: true
    validates :track_count, numericality: { greater_than: 0 }
    validates :generator, on: :create, presence: true

    accepts_nested_attributes_for :entries

    attr_accessor :generator
    after_create :perform_generator

    def generator= generator
      if generator.present?
        @generator = generator.constantize.new(list: self) rescue nil
      else
        @generator = generator
      end
    end

    def perform_generator
      generator.perform
    end
  end
end
