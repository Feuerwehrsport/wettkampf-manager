# frozen_string_literal: true

class BandDecorator < ApplicationDecorator
  decorates_association :assessments
  decorates_association :tags
  decorates_association :person_tags
  decorates_association :team_tags

  delegate :to_s, to: :name

  def translated_gender
    gender.present? ? t("gender.#{gender}") : ''
  end
end
