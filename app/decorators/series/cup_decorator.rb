class Series::CupDecorator < ApplicationDecorator
  decorates_association :round
  decorates_association :competition

  delegate :to_s, to: :competition
end
