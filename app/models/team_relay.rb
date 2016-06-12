class TeamRelay < CacheDependendRecord
  belongs_to :team
  has_many :list_entries, class_name: "Score::ListEntry", as: :entity, dependent: :destroy
  
  validates :team, :number, presence: true

  def name
    (64+number).chr
  end

  def self.create_next_free_for team, not_ids
    existing = where(team: team).where.not(id: not_ids).order(:number).first
    return existing if existing.present?
    create_next_free team
  end

  def self.create_next_free team
    new_number = (team.team_relays.order(:number).pluck(:number).last || 0) + 1
    team.team_relays.create(number: new_number)
  end
end
