class Score::GroupResultRowDecorator < ApplicationDecorator
  decorates_association :team
  decorates_association :result_entry
  decorates_association :rows_in
  decorates_association :rows_out
end
