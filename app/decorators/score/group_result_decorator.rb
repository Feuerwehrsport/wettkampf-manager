class Score::GroupResultDecorator < ApplicationDecorator
  decorates_association :assessment

  def rows
    @rows ||= object.rows.map(&:decorate)
  end
end
