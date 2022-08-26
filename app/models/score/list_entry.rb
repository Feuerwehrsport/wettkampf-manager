# frozen_string_literal: true

class Score::ListEntry < CacheDependendRecord
  include Score::ResultEntrySupport
  edit_time(:time_left_target)
  edit_time(:time_right_target)
  BEFORE_CHECK_METHODS =
    %i[result_type edit_second_time edit_second_time_left_target edit_second_time_right_target].freeze

  belongs_to :list, class_name: 'Score::List', inverse_of: :entries
  belongs_to :entity, polymorphic: true
  belongs_to :assessment
  has_many :api_time_entries, class_name: 'API::TimeEntry', inverse_of: :score_list_entry, dependent: :nullify,
                              foreign_key: :score_list_entry_id

  enum assessment_type: { group_competitor: 0, single_competitor: 1, out_of_competition: 2 }

  validates :list, :entity, :track, :run, :assessment_type, :assessment, presence: true
  validates :track, :run, numericality: { greater_than: 0 }
  validates :track, numericality: { less_than_or_equal_to: :track_count }
  validate :check_changed_while_editing, on: :update

  before_validation do
    if list.separate_target_times?
      self.time = ([time_left_target, time_right_target].max if time_left_target.present? && time_right_target.present?)
    end
  end

  delegate :track_count, to: :list

  scope :result_valid, -> { where(result_type: :valid) }
  scope :not_waiting, -> { where.not(result_type: :waiting) }
  scope :waiting, -> { where(result_type: :waiting) }

  BEFORE_CHECK_METHODS.each do |method_name|
    define_method(:"#{method_name}_before") do
      send(method_name)
    end
    attr_writer :"#{method_name}_before"
  end
  attr_accessor :changed_while_editing

  def self.insert_random_values
    where(result_type: :waiting).find_each do |l|
      if l.list.separate_target_times?
        l.update!(time_with_valid_calculation: rand(1900..2300),
                  time_left_target: rand(1900..2300), time_right_target: rand(1900..2300))
      else
        l.update!(time_with_valid_calculation: rand(1900..2300))
      end
    end
  end

  private

  def check_changed_while_editing
    datebase_entry = self.class.find(id)
    changed_while_editing = BEFORE_CHECK_METHODS.any? do |method_name|
      value_before = instance_variable_get(:"@#{method_name}_before")
      value_before.present? && value_before.to_s != datebase_entry.send(method_name).to_s
    end

    errors.add(:changed_while_editing) if changed_while_editing
  end
end
