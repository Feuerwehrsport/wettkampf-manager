class Series::TeamParticipation < Series::Participation
  belongs_to :team, class_name: 'FireSportStatistics::Team'

  validates :team, :team_number, presence: true

  def entity_id
    "#{team_id}-#{team_number}"
  end
end