class FireSportStatistics::TeamSpelling < ActiveRecord::Base
  include FireSportStatistics::TeamScopes
  belongs_to :team

  validates :name, :short, :team, presence: true
end
