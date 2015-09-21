require 'score'

module Score
  class Result < ActiveRecord::Base
    belongs_to :assessment
    belongs_to :double_event_result, dependent: :destroy
    has_many :result_lists, dependent: :destroy
    has_many :lists, through: :result_lists

    validates :assessment, presence: true

    default_scope { includes(:assessment).order("assessments.discipline_id", "assessments.gender") }
    scope :gender, -> (gender) { joins(:assessment).merge(Assessment.gender(gender)) }
    scope :group_assessment_for, -> (gender) { gender(gender).where(group_assessment: true) }
    scope :discipline, -> (discipline) { where(assessment: Assessment.discipline(discipline)) }

    def to_label
      decorate.to_s
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

    def generate_rows(group_result=false)
      out_of_competition_rows = {}
      rows = {}
      lists.each do |list|
        list.entries.not_waiting.each do |list_entry|
          next if list_entry.assessment != assessment
          entity = list_entry.entity
          entity = entity.team if group_result && entity.is_a?(TeamRelay)
          next if youth? && !entity.youth?

          if list_entry.out_of_competition?
            if out_of_competition_rows[entity.id].nil?
              out_of_competition_rows[entity.id] = ResultRow.new(entity, self)
            end
            out_of_competition_rows[entity.id].add_list(list_entry)
          else
            if rows[entity.id].nil?
              rows[entity.id] = ResultRow.new(entity, self)
            end
            rows[entity.id].add_list(list_entry)
          end
        end
      end
      @out_of_competition_rows = out_of_competition_rows.values
      rows.values
    end
  end
end
