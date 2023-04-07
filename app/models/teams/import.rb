class Teams::Import
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  include Draper::Decoratable

  attr_accessor :import_rows, :band_id

  def save
    teams.all?(&:save!)
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:import_rows, e.message)
    false
  end

  def teams
    @teams ||= build_teams
  end

  protected

  def build_teams
    import_rows.to_s.lines.map(&:strip).reject(&:blank?).map do |team_name|
      Team.new(name: team_name, shortcut: Imports::Team.clean_and_cut_shortcut(team_name), band_id: band_id)
    end.select(&:valid?)
  end
end
