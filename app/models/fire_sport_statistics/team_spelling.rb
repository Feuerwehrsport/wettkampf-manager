module FireSportStatistics
  class TeamSpelling < ActiveRecord::Base
    include TeamScopes
    belongs_to :team

    validates :name, :short, :team, presence: true
  end
end
