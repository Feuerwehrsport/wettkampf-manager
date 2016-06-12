class Score::ListEntry < CacheDependendRecord
  include Score::ResultEntrySupport

  belongs_to :list, class_name: 'Score::List'
  belongs_to :entity, polymorphic: true
  belongs_to :assessment
  
  enum assessment_type: { group_competitor: 0, single_competitor: 1, out_of_competition: 2 }

  validates :list, :entity, :track, :run, :assessment_type, :assessment, presence: true
  validates :track, :run, numericality: { greater_than: 0 }
  validates :track, numericality: { less_than_or_equal_to: :track_count }

  delegate :track_count, to: :list

  scope :result_valid, -> { where(result_type: :valid) }
  scope :not_waiting, -> { where.not(result_type: :waiting) }
end
