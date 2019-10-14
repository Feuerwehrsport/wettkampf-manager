class Series::Participation < ApplicationRecord
  belongs_to :cup, class_name: 'Series::Cup', inverse_of: :participations
  belongs_to :assessment, class_name: 'Series::Assessment', inverse_of: :participations

  validates :cup, :assessment, :time, :points, :rank, presence: true

  def result_entry
    @result_entry = Score::ResultEntry.new(time_with_valid_calculation: time)
  end
end
