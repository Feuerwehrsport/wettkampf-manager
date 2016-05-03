module Series
  class Cup < ActiveRecord::Base
    TODAY_ID = 99999000
    include Participationable

    belongs_to :round
    has_many :assessments, through: :round
    has_many :participations, dependent: :destroy

    default_scope -> { order(:competition_date) }

    validates :round, :competition_place, :competition_date, presence: true

    def self.create_today!
      id = TODAY_ID
      Round.all.each do |round|
        id += 1
        create!(round: round, id: id, competition_date: Date.today, competition_place: "-")
      end
    end

    def self.today_cup_for_round(round)
      round.cups.where("id > ?", TODAY_ID).first
    end

    def competition_place
      persisted? && id > TODAY_ID ? Competition.one.place : super
    end

    def competition_date
      persisted? && id > TODAY_ID ? Competition.one.date : super
    end
  end
end
