class Series::Participation < ActiveRecord::Base
  belongs_to :cup, class_name: 'Series::Cup'
  belongs_to :assessment, class_name: 'Series::Asessment'

  validates :cup, :assessment, :time, :points, :rank, presence: true
end
