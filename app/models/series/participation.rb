class Series::Participation < ActiveRecord::Base
  belongs_to :cup, class_name: 'Series::Cup'
  belongs_to :assessment, class_name: 'Series::Assessment'

  validates :cup, :assessment, :time, :points, :rank, presence: true

  def result_entry
    @result_entry = Score::ResultEntry.new(time_with_valid_calculation: time)
  end
end
