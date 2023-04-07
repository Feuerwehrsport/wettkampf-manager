# frozen_string_literal: true

class Score::ListFactories::TrackSame < Score::ListFactory
  validates :before_list, presence: true, if: -> { step_reached?(:finish) }
  validate :before_list_assessments_match, if: -> { step_reached?(:finish) }

  def self.generator_params
    [:before_list]
  end

  def perform
    transaction do
      before_list.entries.each do |entry|
        create_list_entry(entry, entry.run, entry.track)
      end
    end
  end

  private

  def before_list_assessments_match
    return unless before_list.blank? || before_list.assessment_ids.sort != assessment_ids.sort

    errors.add(:before_list, 'muss mit jetziger Wertung übereinstimmen')
  end
end
