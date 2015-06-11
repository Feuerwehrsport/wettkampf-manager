module Score
  class ListGenerator

    include ActiveModel::Model
    include ActiveRecord::AttributeAssignment
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include ActiveModel::Translation

    attr_accessor :list, :before_list, :best_count, :result
    validates :list, presence: true
    delegate :assessment, to: :list

    def self.configuration
      {
        "Score::ListGenerators::Simple" => [],
        "Score::ListGenerators::GroupOrder" => [],
        "Score::ListGenerators::FireRelay" => [],
        "Score::ListGenerators::TrackChange" => [:before_list],
        "Score::ListGenerators::TrackSame" => [:before_list],
        "Score::ListGenerators::Best" => [:result, :best_count],
      }
    end

    def self.all
      self.configuration.keys.map(&:constantize)
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

    def create_list_entry(request, run, track)
      list.entries.create!(entity: request.entity, run: run, track: track, assessment_type: request.assessment_type)
    end

    def perform_rows
      []
    end
  end
end