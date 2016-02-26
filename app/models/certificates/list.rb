module Certificates
  class List
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
      Template.find_by_id(template_id)
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
          time = row.sum_stopwatch_time
        else
          time = row.best_stopwatch_time
        end

        page_text_values.push(
          team_name: row.entity,
          person_name: row.entity,
          time_long: "#{time} Sekunden" ,
          time_short:  "#{time} s",
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
end