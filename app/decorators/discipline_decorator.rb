class DisciplineDecorator < ApplicationDecorator
  decorates_association :assessments

  def to_s
    name.present? ? name : object.model_name.human
  end

  def image
    "#{object.image}.png"
  end
end
