class Score::ListFactoryAssessment < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :list_factory, class_name: 'Score::ListFactory'
end
