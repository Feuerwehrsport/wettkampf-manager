class DisciplineDecorator < ApplicationDecorator
  decorates_association :assessments

  def to_s
    name.presence || object.model_name.human
  end

  def to_short
    short_name.presence || object.model_name.human(count: 0)
  end

  def image
    "#{object.image}.png"
  end
end
