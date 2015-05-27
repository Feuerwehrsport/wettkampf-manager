module FireSportStatistics
  class Person < ActiveRecord::Base
    enum gender: { female: 0, male: 1 }
    has_many :team_associations
    has_many :teams, through: :team_associations
  
    validates :last_name, :first_name, :gender, presence: true

    scope :where_name_like, -> (name) do
      query = "%#{name.split("").join("%")}%"
      spelling_query = PersonSpelling.where("(first_name || ' ' || last_name) LIKE ?", query).select(:person_id)
      where("(first_name || ' ' || last_name) LIKE ? OR id IN (#{spelling_query.to_sql})", query)
    end

    scope :order_by_gender, -> (gender) do
      order(gender: (gender == 'female') ? :asc : :desc)
    end

    scope :order_by_teams, -> (teams) do
      sql = teams.joins(:team_associations).where(fire_sport_statistics_team_associations: { person_id: arel_table[:id] }).to_sql
      order("EXISTS(#{sql}) DESC")
    end

    def full_name
      "#{first_name} #{last_name}"
    end

    def full_name_changed?
      first_name_changed? || last_name_changed?
    end
  end
end
