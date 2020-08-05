# frozen_string_literal: true

class Score::GroupResultRowDecorator < ApplicationDecorator
  include Certificates::StorageSupport
  decorates_association :team
  decorates_association :entity
  decorates_association :result_entry
  decorates_association :rows_in
  decorates_association :rows_out
  decorates_association :result

  def <=>(other)
    other = other.object if other.is_a?(Draper::Decorator)
    object <=> other
  end
end
