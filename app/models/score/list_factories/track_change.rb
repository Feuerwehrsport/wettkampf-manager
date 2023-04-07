# frozen_string_literal: true

class Score::ListFactories::TrackChange < Score::ListFactory
  validates :before_list, presence: true, if: -> { step_reached?(:finish) }
  validate :before_list_assessment_match, if: -> { step_reached?(:finish) }

  def self.generator_params
    [:before_list]
  end

  def perform
    transaction do
      before_list.entries.each do |entry|
        new_track = (entry.track % list.track_count) + 1
        create_list_entry(entry, entry.run, new_track)
      end
    end
  end

  private

  def before_list_assessment_match
    return unless before_list.blank? || before_list.assessment_ids.sort != assessment_ids.sort

    errors.add(:before_list, 'muss mit jetziger Wertung übereinstimmen')
  end
end
