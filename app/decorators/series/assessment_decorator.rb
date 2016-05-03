module Series
  class AssessmentDecorator < ApplicationDecorator
    decorates_association :cups
    decorates_association :participations
    decorates_association :round

    def to_s
      name
    end
    
    def rows
      object.rows.map(&:decorate)
    end
  end
end
