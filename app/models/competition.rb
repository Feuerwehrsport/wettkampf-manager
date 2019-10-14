class Competition < ApplicationRecord
  has_many :person_tags, dependent: :destroy
  has_many :team_tags, dependent: :destroy

  accepts_nested_attributes_for :person_tags, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :team_tags, reject_if: :all_blank, allow_destroy: true

  before_destroy { false }
  before_create { create_possible || false }
  after_save { self.class.reload_class_instances }

  attr_accessor :create_possible

  validates :name, :date, presence: true
  validates :group_people_count, :group_run_count, :group_score_count, numericality: { greater_than: 0 }
  validates :competition_result_type, inclusion: { in: Score::CompetitionResult.result_types.keys.map(&:to_s) },
                                      allow_blank: true

  def self.one
    @one ||= first
  end

  def self.result_type
    @result_type ||= begin
      result_type = one.competition_result_type.try(:to_sym)
      Score::CompetitionResult.result_types.key?(result_type) ? result_type : nil
    end
  end

  def self.reload_class_instances
    @one = nil
    @result_type = nil
  end

  def hostname_url
    hostname.present? ? "http://#{hostname}/" : ip_url
  end

  def ip_url
    @ip_url ||= "http://#{Socket.ip_address_list.find { |a| a.ipv4? && !a.ipv4_loopback? }.try(:ip_address)}/"
  end
end
