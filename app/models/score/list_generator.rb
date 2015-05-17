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
        "Score::ListGenerators::TrackChange" => [:before_list],
        "Score::ListGenerators::TrackSame" => [:before_list],
        "Score::ListGenerators::Best" => [:result, :best_count],
      }
    end

    def self.all
      self.configuration.keys.map(&:constantize)
    end

    def self.label_method
      model_name.human
    end

    def self.value_method
      name
    end

    def to_param
      p self.class.name 
      self.class.name
    end
  end
end