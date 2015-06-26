module Score
  class ListGenerator

    include ActiveModel::Model
    include ActiveRecord::AttributeAssignment
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include ActiveModel::Translation

    attr_accessor :list, :before_list, :best_count, :result
    validates :list, presence: true
    delegate :assessments, to: :list

    def self.configuration
      {
        "Score::ListGenerators::Simple" => Configuration.new { |discipline| !discipline.is_a?(Disciplines::FireRelay) },
        "Score::ListGenerators::GroupOrder" => Configuration.new { |discipline| discipline.single_discipline? },
        "Score::ListGenerators::FireRelay" => Configuration.new { |discipline| discipline.is_a?(Disciplines::FireRelay) },
        "Score::ListGenerators::TrackChange" => Configuration.new([:before_list]) { |discipline| !discipline.is_a?(Disciplines::FireRelay) },
        "Score::ListGenerators::TrackSame" => Configuration.new([:before_list]) { |discipline| !discipline.is_a?(Disciplines::FireRelay) },
        "Score::ListGenerators::Best" => Configuration.new([:result, :best_count]) { |discipline| !discipline.is_a?(Disciplines::FireRelay) },
      }
    end

    def self.all
      self.configuration.keys.map(&:constantize)
    end

    def self.for_discipline?(discipline)
      configuration.select { |key, c| c.for_discipline?(discipline) }.keys.map(&:constantize)
    end

    def self.value_method
      name
    end

    def self.to_label
      model_name.human
    end

    def to_param
      self.class.name
    end

    def perform
      for_run_and_track_for(perform_rows)
    end

    protected

    def for_run_and_track_for rows
      rows = rows.dup
      run = 0
      list.transaction do
        while true
          run += 1
          for track in (1..list.track_count)
            row = rows.shift
            return if row.nil?
            create_list_entry(row, run, track)
          end

          if run > 1000
            raise "Something went wrong"
          end
        end
      end
    end

    def assessment_requests
      requests = []
      assessments.each { |assessment| requests += assessment.requests.to_a }
      requests
    end

    def create_list_entry(request, run, track)
      list.entries.create!(
        entity: request.entity, 
        run: run, 
        track: track, 
        assessment_type: request.assessment_type,
        assessment: request.assessment
      )
    end

    def perform_rows
      []
    end

    class Configuration
      attr_reader :generator_attributes
      def initialize(generator_attributes=[], &block)
        @generator_attributes = generator_attributes
        @for_discipline = block
      end

      def for_discipline? discipline
        return true if @for_discipline.nil?
        @for_discipline.call(discipline)
      end
    end
  end
end