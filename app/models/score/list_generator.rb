module Score
  class ListGenerator

    include ActiveModel::Model
    include ActiveRecord::AttributeAssignment
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    attr_accessor :list
    validates :list, presence: true
    delegate :assessment, to: :list

    def self.all
      [
        ListGenerators::Simple
      ]
    end

    def self.label_method
      model_name.human
    end

    def self.value_method
      name
    end
  end
end