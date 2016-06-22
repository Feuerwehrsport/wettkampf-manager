class FireSportStatistics::Person < ActiveRecord::Base
  enum gender: { female: 0, male: 1 }
  has_many :team_associations, class_name: 'FireSportStatistics::TeamAssociation'
  has_many :teams, through: :team_associations, class_name: 'FireSportStatistics::Team'
  has_one :person, class_name: '::Person', inverse_of: :fire_sport_statistics_person, foreign_key: :fire_sport_statistics_person_id

  validates :last_name, :first_name, :gender, presence: true

  scope :where_name_like, -> (name) do
    query = "%#{name.split("").join("%")}%"
    spelling_query = FireSportStatistics::PersonSpelling.where("(first_name || ' ' || last_name) LIKE ?", query).select(:person_id)
    where("(first_name || ' ' || last_name) LIKE ? OR id IN (#{spelling_query.to_sql})", query)
  end
  scope :order_by_gender, -> (gender) do
    order(gender: (gender == 'female') ? :asc : :desc)
  end
  scope :order_by_teams, -> (teams) do
    sql = teams.joins(:team_associations).where(fire_sport_statistics_team_associations: { person_id: arel_table[:id] }).to_sql
    order("EXISTS(#{sql}) DESC")
  end
  scope :gender, -> (gender) { where(gender: genders[gender]) }
  scope :for_person, -> (person) do
    where_name_like("#{person.first_name}#{person.last_name}").gender(person.gender)
  end
  scope :dummies, -> { where(dummy: true) }

  def self.dummy(person)
    find_or_create_by(last_name: person.last_name, first_name: person.first_name, gender: person.gender, dummy: true)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_changed?
    first_name_changed? || last_name_changed?
  end
end
