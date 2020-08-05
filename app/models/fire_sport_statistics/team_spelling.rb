# frozen_string_literal: true

class FireSportStatistics::TeamSpelling < ApplicationRecord
  include FireSportStatistics::TeamScopes
  belongs_to :team

  validates :name, :short, :team, presence: true
end
