class Certificates::List
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::Callbacks
  include Draper::Decoratable
  attr_accessor :template_id, :score_result_id, :competition_result_id, :group_score_result_id, :image

  validates :template, presence: true
  validate :result_present

  def template
    Certificates::Template.find_by(id: template_id)
  end

  def score_result
    @score_result ||= Score::Result.find_by(id: score_result_id)
  end

  def group_score_result
    @group_score_result ||= begin
      result = Score::Result.find_by(id: group_score_result_id)
      Score::GroupResult.new(result) if result
    end
  end

  def competition_result
    @competition_result ||= Score::CompetitionResult.find_by(id: competition_result_id)
  end

  def result
    @result ||= score_result || competition_result || group_score_result
  end

  def rows
    @rows ||= result.try(:rows)
  end

  def save
    valid?
  end

  private

  def result_present
    return if [score_result, competition_result, group_score_result].select(&:itself).count == 1
    errors.add(:score_result_id, :invalid)
    errors.add(:competition_result_id, :invalid)
    errors.add(:group_score_result_id, :invalid)
  end
end
