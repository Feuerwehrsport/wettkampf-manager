# frozen_string_literal: true

class Score::Result < CacheDependendRecord
  include Taggable
  include Score::Resultable
  CALCULATION_METHODS = { default: 0, sum_of_two: 1 }.freeze
  enum calculation_method: CALCULATION_METHODS

  belongs_to :assessment, inverse_of: :results
  has_many :series_assessment_results, class_name: 'Series::AssessmentResult', dependent: :destroy,
                                       foreign_key: :score_result_id, inverse_of: :score_result
  has_many :series_assessments, through: :series_assessment_results, source: :assessment,
                                class_name: 'Series::Assessment'
  belongs_to :double_event_result, dependent: :destroy, class_name: 'Score::DoubleEventResult', inverse_of: :results
  has_many :result_lists, dependent: :destroy, inverse_of: :result
  has_many :lists, through: :result_lists
  delegate :discipline, to: :assessment

  validates :assessment, presence: true

  # default_scope { includes(:assessment).order('assessments.discipline_id', 'assessments.gender') }
  scope :gender, ->(gender) { joins(:assessment).merge(Assessment.gender(gender)) }
  scope :group_assessment_for, ->(gender) { gender(gender).where(group_assessment: true) }
  scope :discipline, ->(discipline) { where(assessment: Assessment.discipline(discipline)) }

  def to_label
    decorate.to_s
  end

  def possible_series_assessments
    Series::Assessment.gender(assessment.band.gender).where(discipline: assessment.discipline.key)
  end

  def single_group_result?
    group_assessment? && discipline.single_discipline?
  end

  def rows
    @rows ||= generate_rows.sort
  end

  def out_of_competition_rows
    generate_rows if @out_of_competition_rows.nil?
    @out_of_competition_rows
  end

  def group_result_rows
    @group_result_rows ||= generate_rows(true).sort
  end

  def person_tags
    @person_tags ||= tags.where(type: 'PersonTag')
  end

  def team_tags
    @team_tags ||= tags.where(type: 'TeamTag')
  end

  def generate_rows(group_result = false)
    out_of_competition_rows = {}
    rows = {}
    lists.each do |list|
      list.entries.not_waiting.each do |list_entry|
        next if list_entry.assessment != assessment

        entity = list_entry.entity
        entity = entity.team if group_result && entity.is_a?(TeamRelay)
        next if tags.present? && skip?(entity)

        if list_entry.out_of_competition?
          if out_of_competition_rows[entity.id].nil?
            out_of_competition_rows[entity.id] = Score::ResultRow.new(entity, self)
          end
          out_of_competition_rows[entity.id].add_list(list_entry)
        else
          rows[entity.id] = Score::ResultRow.new(entity, self) if rows[entity.id].nil?
          rows[entity.id].add_list(list_entry)
        end
      end
    end
    @out_of_competition_rows = out_of_competition_rows.values
    rows.values
  end

  def group_result
    @group_result ||= Score::GroupResult.new(self)
  end

  protected

  def skip?(entity)
    case entity
    when TeamRelay
      !entity.team.include_tags?(team_tags)
    when Team
      !entity.include_tags?(team_tags)
    when Person
      return true unless entity.include_tags?(person_tags)
      return false if team_tags.blank?
      return false if entity.team.blank?

      !entity.team.include_tags?(team_tags)
    else
      true
    end
  end
end
