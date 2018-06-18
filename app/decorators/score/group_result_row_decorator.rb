class Score::GroupResultRowDecorator < ApplicationDecorator
  include Certificates::StorageSupport
  decorates_association :team
  decorates_association :entity
  decorates_association :result_entry
  decorates_association :rows_in
  decorates_association :rows_out

  def <=>(other)
    object <=> other.object
  end
end
