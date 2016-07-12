class FireSportStatistics::Team < ActiveRecord::Base
  include FireSportStatistics::TeamScopes
  has_many :team_associations, class_name: 'FireSportStatistics::TeamAssociation'
  has_one :team, class_name: '::Team', inverse_of: :fire_sport_statistics_team, foreign_key: :fire_sport_statistics_team_id
  belongs_to :federal_state
  validates :name, :short, presence: true

  scope :where_name_like, -> (name) do
    name = name.strip.gsub(/^FF\s/i, "").gsub(/^Team\s/i, "").strip

    in_names = FireSportStatistics::Team.select(:id).like_name_or_short(name).to_sql
    in_spellings = FireSportStatistics::TeamSpelling.select(FireSportStatistics::TeamSpelling.arel_table[:team_id].as("id")).like_name_or_short(name).to_sql
    where("#{table_name}.id IN (#{in_names}) OR #{table_name}.id IN (#{in_spellings})")
  end
  scope :for_team, -> (team) do
    where_name_like("#{team.name}")
  end
  scope :dummies, -> { where(dummy: true) }

  def self.dummy(team)
    self.find_or_create_by(name: team.name, short: team.shortcut, dummy: true)
  end
end