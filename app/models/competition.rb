class Competition < ActiveRecord::Base
  before_destroy { false }
  before_create { create_possible || false }
  after_save { self.class.reload_class_instances }

  attr_accessor :create_possible

  validates :name, :date, presence: true
  validates :group_people_count, :group_run_count, :group_score_count, numericality: { greater_than: 0 }
  validates :competition_result_type, inclusion: { in: Score::CompetitionResult.result_types.keys.map(&:to_s) }, allow_blank: true

  def self.one
    @one ||= first
  end

  def self.result_type
    @result_type ||= begin
      result_type = one.competition_result_type.try(:to_sym)
      Score::CompetitionResult.result_types.keys.include?(result_type) ? result_type : nil
    end
  end 

  def self.reload_class_instances
    @one = nil
    @result_type = nil
  end
end
