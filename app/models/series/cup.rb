# frozen_string_literal: true

class Series::Cup < ApplicationRecord
  TODAY_ID = 99_999_000
  include Series::Participationable

  belongs_to :round, class_name: 'Series::Round', inverse_of: :cups
  has_many :assessments, through: :round, class_name: 'Series::Assessment'
  has_many :participations, dependent: :destroy, class_name: 'Series::Participation', inverse_of: :cup

  default_scope -> { order(:competition_date) }

  validates :round, :competition_place, :competition_date, presence: true

  def self.create_today!
    id = TODAY_ID
    Series::Round.all.find_each do |round|
      id += 1
      create!(round: round, id: id, competition_date: Date.current, competition_place: '-')
    end
  end

  def self.today_cup_for_round(round)
    round.cups.find_by('id > ?', TODAY_ID)
  end

  def competition_place
    persisted? && id > TODAY_ID ? Competition.one.place : super
  end

  def competition_date
    persisted? && id > TODAY_ID ? Competition.one.date : super
  end
end
