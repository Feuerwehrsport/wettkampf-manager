class Series::ParticipationRows::BaseDecorator < ApplicationDecorator
  decorates_association :round
  decorates_association :entity

  def participation_for_cup(cup)
    object.participation_for_cup(cup).try(:decorate)
  end
end
