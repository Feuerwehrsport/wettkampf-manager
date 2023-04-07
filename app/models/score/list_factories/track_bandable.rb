# frozen_string_literal: true

class Score::ListFactories::TrackBandable < Score::ListFactories::GroupOrder
  validates :track, :bands, presence: true, if: -> { step_reached?(:finish) }
  validates :track, numericality: { only_integer: true, graeter_than: 0, less_than_or_equal_to: :track_count },
                    if: -> { step_reached?(:finish) }

  def self.generator_params
    %i[track bands single_competitors_first]
  end

  def perform
    band_rows = []
    other_rows = []
    perform_rows.each do |row|
      if row.entity.band.in?(bands)
        band_rows.push(row)
      else
        other_rows.push(row)
      end
    end
    for_run_and_track_for(band_rows, [track])
    for_run_and_track_for(other_rows, (1..list.track_count).to_a - [track])
  end
end
