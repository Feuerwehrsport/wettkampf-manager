class FireSportStatistics::Team < ActiveRecord::Base
  include FireSportStatistics::TeamScopes
  has_many :team_associations, class_name: 'FireSportStatistics::TeamAssociation'
  validates :name, :short, presence: true

  scope :where_name_like, -> (name) do
    name = name.strip.gsub(/^FF\s/i, "").gsub(/^Team\s/i, "").strip

    in_names = FireSportStatistics::Team.select(:id).like_name_or_short(name).to_sql
    in_spellings = FireSportStatistics::TeamSpelling.select(FireSportStatistics::TeamSpelling.arel_table[:team_id].as("id")).like_name_or_short(name).to_sql
    where("#{table_name}.id IN (#{in_names}) OR #{table_name}.id IN (#{in_spellings})")
  end
end