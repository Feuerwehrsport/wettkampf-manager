class Score::List < CacheDependendRecord
  has_many :list_assessments, dependent: :destroy
  has_many :assessments, through: :list_assessments
  has_many :result_lists, dependent: :destroy
  has_many :results, through: :result_lists
  has_many :entries, -> { order(:run).order(:track) }, class_name: "Score::ListEntry", dependent: :destroy

  default_scope { order(:name) }

  validates :name, :assessments, :track_count, :shortcut, presence: true
  validates :track_count, numericality: { greater_than: 0 }
  validates :shortcut, length: { maximum: 8 }
  accepts_nested_attributes_for :entries, allow_destroy: true

  def next_free_track
    last_entry = entries.last
    run = last_entry.try(:run) || 1
    track = last_entry.try(:track) || 1
    track += 1
    if track > track_count
      track = 1
      run += 1
    end
    [run, track]
  end
end
