# frozen_string_literal: true

class Score::ListFactories::TrackGenderable < Score::ListFactories::GroupOrder
  validates :track, :gender, presence: true, if: -> { step_reached?(:finish) }
  validates :track, numericality: { only_integer: true, graeter_than: 0, less_than_or_equal_to: :track_count },
                    if: -> { step_reached?(:finish) }

  def self.generator_params
    %i[track gender]
  end

  def perform
    gender_rows = []
    other_rows = []
    perform_rows.each do |row|
      if gender == row.entity.gender
        gender_rows.push(row)
      else
        other_rows.push(row)
      end
    end
    for_run_and_track_for(gender_rows, [track])
    for_run_and_track_for(other_rows, (1..list.track_count).to_a - [track])
  end
end
