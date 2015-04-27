module FireSportStatistics
  class Team < ActiveRecord::Base
    include TeamScopes
    has_many :team_associations
    validates :name, :short, :external_id, presence: true

    scope :where_name_like, -> (name) do
      name = name.strip.gsub(/^FF\s/i, "").gsub(/^Team\s/i, "").strip

      in_names = Team.select(:id).like_name_or_short(name).to_sql
      in_spellings = TeamSpelling.select(TeamSpelling.arel_table[:team_id].as("id")).like_name_or_short(name).to_sql
      where("#{table_name}.id IN (#{in_names}) OR #{table_name}.id IN (#{in_spellings})")
    end
  end
end