# frozen_string_literal: true

class Score::ResultEntry
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  include Score::ResultEntrySupport
  include Draper::Decoratable

  attr_accessor :time, :result_type

  def self.invalid
    new(time_with_valid_calculation: nil)
  end
end
