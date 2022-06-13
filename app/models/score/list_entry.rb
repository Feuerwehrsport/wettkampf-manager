# frozen_string_literal: true

class Score::ListEntry < CacheDependendRecord
  include Score::ResultEntrySupport
  edit_time(:time_left_target)
  edit_time(:time_right_target)

  belongs_to :list, class_name: 'Score::List', inverse_of: :entries
  belongs_to :entity, polymorphic: true
  belongs_to :assessment
  has_many :api_time_entries, class_name: 'API::TimeEntry', inverse_of: :score_list_entry, dependent: :nullify,
                              foreign_key: :score_list_entry_id

  enum assessment_type: { group_competitor: 0, single_competitor: 1, out_of_competition: 2 }

  validates :list, :entity, :track, :run, :assessment_type, :assessment, presence: true
  validates :track, :run, numericality: { greater_than: 0 }
  validates :track, numericality: { less_than_or_equal_to: :track_count }

  before_validation do
    if list.separate_target_times?
      self.time = ([time_left_target, time_right_target].max if time_left_target.present? && time_right_target.present?)
    end
  end

  delegate :track_count, to: :list

  scope :result_valid, -> { where(result_type: :valid) }
  scope :not_waiting, -> { where.not(result_type: :waiting) }
  scope :waiting, -> { where(result_type: :waiting) }

  def self.insert_random_values
    where(result_type: :waiting).find_each { |l| l.update!(time_with_valid_calculation: rand(1900..2300)) }
  end
end
