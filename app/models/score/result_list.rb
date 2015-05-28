class Score::ResultList < ActiveRecord::Base
  belongs_to :list
  belongs_to :result
end
