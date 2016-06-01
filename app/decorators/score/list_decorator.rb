class Score::ListDecorator < ApplicationDecorator
  def discipline
    object.assessments.first.discipline.decorate
  end

  def to_s
    name
  end
end