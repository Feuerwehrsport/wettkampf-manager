class Certificates::List
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::Callbacks
  include Draper::Decoratable
  attr_accessor :template_id, :score_result_id, :score_result, :image

  validates :template, :score_result, presence: true

  def template
    Certificates::Template.find_by_id(template_id)
  end

  def score_result
    Score::Result.find_by_id(score_result_id)
  end

  def save
    valid?
  end

  def pages
    page_text_values = []

    result.rows.map(&:decorate).each do |row|
      if row.is_a?(Score::DoubleEventResultRow)
        result_entry = row.sum_result_entry
      else
        result_entry = row.best_result_entry
      end

      page_text_values.push(
        team_name: row.entity,
        person_name: row.entity,
        time_long: result_entry.long_human_time(seconds: 'Sekunden') ,
        time_short:  result_entry.long_human_time(seconds: 's'),
        rank: "#{place_for_row row}.",
        assessment: assessment,
        assessment_with_gender: assessment,
        gender: assessment.gender,
        date: Competition.one.date,
        place: Competition.one.place,
        competition_name: Competition.name,
      )
    end
  end
end