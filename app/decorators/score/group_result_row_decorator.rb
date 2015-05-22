module Score
  class GroupResultRowDecorator < ApplicationDecorator
    decorates_association :team
    decorates_association :time
    decorates_association :rows_in
    decorates_association :rows_out
  end
end