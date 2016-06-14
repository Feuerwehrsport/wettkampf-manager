class Score::ListFactory < CacheDependendRecord
  include Score::ListFactoryDefaults

  STEPS = %i(discipline assessments names tracks results generator generator_params finish create)
  GENERATORS = [
    Score::ListFactories::GroupOrder,
    Score::ListFactories::LotteryNumber,
    Score::ListFactories::Simple,
    Score::ListFactories::Best,
    Score::ListFactories::FireRelay,
    Score::ListFactories::TrackChange,
    Score::ListFactories::TrackSame,
  ]

  belongs_to :discipline
  belongs_to :before_list, class_name: 'Score::List'
  belongs_to :before_result, class_name: 'Score::Result'
  has_many :list_factory_assessments, dependent: :destroy
  has_many :assessments, through: :list_factory_assessments
  has_many :result_list_factories, dependent: :destroy
  has_many :results, through: :result_list_factories

  default_scope { where.not(status: :create) }

  validates :discipline, presence: true
  validates :status, inclusion: { in: STEPS }, allow_nil: true

  validates :assessments, presence: true, if: -> { step_reached?(:names) }
  validate :assessments_possible, if: -> { step_reached?(:names) }
  validates :name, presence: true, if: -> { step_reached?(:tracks) }
  validates :shortcut, presence: true, length: { maximum: 8 }, if: -> { step_reached?(:tracks) }
  validates :track_count, numericality: { only_integer: true, graeter_than: 0 }, if: -> { step_reached?(:results) }
  validates :results, presence: true, if: -> { step_reached?(:generator) }
  validate :type_valid, if: -> { step_reached?(:generator_params) }

  attr_writer :next_step
  attr_reader :list
  before_save do
    if status == :generator && next_step == :generator_params && type.constantize.generator_params.empty?
      self.status = :finish
    else
      self.status = next_step || STEPS[1]
    end
  end
  after_save do
    if status_changed? && status == :create
      create_list
      perform
    end
  end

  def possible_types
    GENERATORS.select { |g| g.generator_possible?(discipline) }
  end

  def self.generator_params
    []
  end

  def self.generator_possible?(discipline)
    !discipline.is_a?(Disciplines::FireRelay)
  end

  def preview_entries_count
    assessment_requests.count
  end

  def preview_run_count
    (preview_entries_count.to_f / track_count.to_f).ceil
  end

  def next_step
    @next_step.try(:to_sym)
  end

  def current_step
    status || STEPS[0]
  end

  def status
    super.try(:to_sym)
  end

  def current_step_number
    STEPS.find_index(current_step) || 0
  end

  def next_step_number
    STEPS.find_index(next_step) || STEPS.length - 1
  end

  def step_reached?(step)
    next_step_number >= STEPS.find_index(step)
  end

  def perform
    for_run_and_track_for(perform_rows)
  end

  def default_name
    name.presence || begin
      main_name = assessments.count == 1 ? assessments.first.decorate.to_s : discipline.decorate.to_s
      if !discipline.is_a?(Disciplines::FireRelay)
        run = 1
        loop do
          break if Score::List.where(name: "#{main_name} - Lauf #{run}").blank?
          run += 1
        end
        main_name = "#{main_name} - Lauf #{run}"
      end
      main_name
    end
  end

  protected

  def create_list
    @list ||= Score::List.create!(name: name, shortcut: shortcut, assessments: assessments, results: results, track_count: track_count)
  end

  def for_run_and_track_for rows
    rows = rows.dup
    run = 0
    transaction do
      while true
        run += 1
        for track in (1..list.track_count)
          row = rows.shift
          return if row.nil?
          create_list_entry(row, run, track)
        end

        if run > 1000
          raise "Something went wrong"
        end
      end
    end
  end

  def assessment_requests
    requests = []
    assessments.each { |assessment| requests += assessment.requests.to_a }
    if team_shuffle?
      requests.shuffle
    else
      requests.sort_by { |request| request.entity.try(:lottery_number) }
    end
  end

  def team_shuffle?
    !Competition.one.lottery_numbers?
  end

  def create_list_entry(request, run, track)
    list.entries.create!(
      entity: request.entity, 
      run: run, 
      track: track, 
      assessment_type: request.assessment_type,
      assessment: request.assessment
    )
  end

  def perform_rows
    []
  end

  private

  def assessments_possible
    assessments.each do |assessment|
      unless assessment.in?(possible_assessments)
        errors.add(:assessments, :invalid)
      end
    end
  end

  def results_possible
    results.each do |result|
      unless result.in?(possible_results)
        errors.add(:results, :invalid)
      end
    end
  end

  def type_valid
    errors.add(:type, :invalid) unless type.in?(possible_types.map(&:to_s))
  end
end



